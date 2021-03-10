


import Foundation

func Test1D() {
    let n1d = Num1D(0,0)
    let x1 = n1d.Arange(0, 10)
    Dump1D(x1)
}

func Test2D() {
    do {
        let n1dI = Num1D<Int>()
        let n1dD = Num1D<Double>()
        let n2d = Num2D<Double>()
        let tsvData = try TSV.Read("seeds_dataset.txt")
        let data = try TSV.ToDouble(tsvData)
        let xIndexes = n1dI.Arange(0, 7) 
        let xData = data.IndexingT(xIndexes)
        let yData = data.LineT(7)
        
        ////////////////////////////////////////
        // scaling
        ////////////////////////////////////////
        let scaleMean = xData.Mean()
        let scaleVriance = xData.Variance()
        let scaleStddev = scaleVriance.Sqrt()
        let scaledX = (xData - scaleMean) / scaleStddev
        
        ////////////////////////////////////////
        // KMeans
        ////////////////////////////////////////
        let Clusters = 3
        let maxIter = 100
        let tol = 1e-5
        
        // Initialize
        let rowIndexes = n1dI.Arange(0, yData.Count)
        let shuffled = rowIndexes.Shuffle()
        let initIndexes = shuffled.Slice(0, Clusters)
        let initMeans = scaledX.Indexing(initIndexes)
        
        var means = initMeans
        let predict = n1dI.Create(xData.Row)
        
        for iter in 0..<maxIter {
            
            // EStep
            for m in 0..<xData.Row {
                let distances = n1dD.Create(Clusters)
                for cluster in 0..<Clusters {
                    let subtract = scaledX.Line(m) - means.Line(cluster)
                    let power = subtract.Power(2)
                    let total = power.Total()
                    let distance = sqrt(total)
                    distances[cluster] = distance
                }
                predict[m] = distances.ArgMin()
            }
            
            // MStep
            let newMeans = n2d.Create(Clusters, scaledX.Col)
            for cluster in 0..<Clusters {
                let cIndexes = predict.WhereEq(cluster)
                let cMean = scaledX.Indexing(cIndexes)
                newMeans[cluster] = cMean.Mean().Value
            }
            
            // threshold
            let subtract = means - newMeans
            let power = subtract.Power(2)
            let total = power.TotalX()
            let meansDistance = sqrt(total / Double(Clusters))
            means = newMeans
            print("iter=\(iter), means distance=\(meansDistance)")
            if meansDistance < tol {
                break
            }
        }
        
        Dump2D(means)
        Dump1D(predict)
        
    } catch {
        print("exception", error)
    }
}

class NumXDTest {
    func Main() {
        Test2D()
    }
}

let test = NumXDTest()
test.Main()

// swiftc -emit-executable numxd_test.swift numxd.swift
