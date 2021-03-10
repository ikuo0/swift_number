


import Foundation


//func GenericToDouble<T: Numeric>(_ n: T) -> Double {
//    if let i = n as? Int {
//        return Double(i)
//    } else if let i = n as? Double {
//        return Double(i)
//    }
//    return Double(-1)
//}

func GenericToDouble<T: Numeric>(_ n: T) -> Double {
    switch T.self {
        case is Int.Type:
            return Double(n as! Int)
        case is Double.Type:
            return Double(n as! Double)
        default:
            return Double(n as! Int)
    }
}

func WriteGVariable<T: Numeric, U: Numeric>(_ dst: inout T, _ src: U) {
    let srcDbl = GenericToDouble(src)
    if T.self is Double.Type {
        dst = srcDbl as! T
    } else if T.self is Int.Type {
        dst = Int(srcDbl) as! T
    }
}

class Num1D<T: Numeric> {
    enum Err: Error {
        case Generic(String)
    }
    
    let Count: Int
    var Value: [T] = []
    
    init(_ count: Int = 0, _ initValue: T = 0) {
        self.Count = count
        for _ in 0..<self.Count {
            self.Value.append(initValue)
        }
    }
    
    init(_ src: [T]) {
        self.Count = src.count
        self.Value = src
    }
    
    subscript(index: Int) -> T {
        get {
            return self.Value[index]
        }
        set {
            self.Value[index] = newValue
        }
    }
    
    func Create(_ count: Int) -> Num1D<T> {
        return Num1D<T>(count, 0)
    }
    func Clone() -> Num1D<T> {
        let dst = Num1D<T>(self.Count, 0)
        for i in 0..<dst.Count {
            dst[i] = self[i]
        }
        return dst
    }
    
    func Arange(_ start: Int, _ end: Int, _ step: Int = 1) -> Num1D<T> {
        let count = end - start
        let dst = self.Create(count)
        for i in 0..<count {
            dst[i] = (start + i * step) as! T
        }
        return dst
    }
    
    func Random(_ count: Int, _ minVal: T, _ maxVal: T) -> Num1D<T> {
        let dst = Create(count)
        for i in 0..<count {
            let minN = GenericToDouble(minVal)
            let maxN = GenericToDouble(maxVal)
            let r = Double.random(in: minN..<maxN)
            WriteGVariable(&dst[i], r)
        }
        return dst
    }
    func Shuffle() -> Num1D<T> {
        return Num1D(self.Value.shuffled())
    }
    
    ////////////////////////////////////////
    // index operation
    ////////////////////////////////////////
    func ArgSort() -> Num1D<Int> {
        let dst = Num1D<Int>(self.Count, 0)
        let sorted = self.Value.enumerated().sorted(by: {
            let dif = ($0.element as! Double) - ($1.element as! Double)
            if dif < 0 {
                return true
            } else if dif > 0 {
                return false
            } else {
                return true
            }
        })
        for (i, v) in sorted.enumerated() {
            dst[i] = v.offset
        }
        return dst
    }
    func ArgMin() -> Int {
        let indexes = self.ArgSort()
        return indexes[0]
    }
    
    func WhereEq(_ b: T) -> Num1D<Int> {
        var indexes: [Int] = []
        for i in 0..<self.Count {
            if(self[i] == b) {
                indexes.append(i)
            }
        }
        return Num1D<Int>(indexes)
    }
    
    ////////////////////////////////////////
    // calculation
    ////////////////////////////////////////
    static func - (_ a: Num1D<T>, _ b: Num1D<T>) -> Num1D<T> {
        let n1d = Num1D<T>()
        let answer = n1d.Create(a.Count)
        for i in 0..<answer.Count {
            answer[i] = a[i] - b[i]
        }
        return answer
    }
    
    static func / (_ a: Num1D<T>, _ b: T) -> Num1D<T> {
        let n1d = Num1D<T>()
        let answer = n1d.Create(a.Count)
        for i in 0..<answer.Count {
            //answer[i] = (a[i] / b[i]) as! T
            let d1 = GenericToDouble(a[i])
            let d2 = GenericToDouble(b)
            let ans = d1 / d2
            answer[i] = ans as! T
        }
        return answer
    }
    
    static func / (_ a: Num1D<T>, _ b: Num1D<T>) -> Num1D<T> {
        let n1d = Num1D<T>()
        let answer = n1d.Create(a.Count)
        for i in 0..<answer.Count {
            //answer[i] = (a[i] / b[i]) as! T
            let d1 = GenericToDouble(a[i])
            let d2 = GenericToDouble(b[i])
            let ans = d1 / d2
            answer[i] = ans as! T
        }
        return answer
    }
    
    func Power(_ b: Double) -> Num1D<T> {
        let answer = self.Clone()
        for i in 0..<answer.Count {
            let a = GenericToDouble(answer[i])
            WriteGVariable(&answer[i], pow(a, b))
        }
        return answer
    }
    
    func Sqrt() -> Num1D<T> {
        let answer = self.Clone()
        for i in 0..<answer.Count {
            let a = GenericToDouble(answer[i])
            WriteGVariable(&answer[i], sqrt(a))
        }
        return answer
    }
    
    func Total() -> T {
        var total: T = 0
        for i in 0..<self.Count {
            total += self[i]
        }
        return total
    }
    ////////////////////////////////////////
    // edit operation
    ////////////////////////////////////////
    func Slice(_ start: Int, _ end: Int) -> Num1D<T> {
        let count = end - start
        let dst = self.Create(count)
        for i in 0..<count {
            dst[i] = self[start + i]
        }
        return dst
    }
}

func Dump1D<T>(_ x: Num1D<T>) -> Void {
    for i in 0..<x.Count {
        print(x[i], terminator: "")
        if(i < (x.Count - 1)) {
            print(", ", terminator: "")
        }
    }
    print()
}

class Num2D<T: Numeric> {
    enum Err: Error {
        case Generic(String)
    }
    
    let Row: Int
    let Col: Int
    var Value: [[T]] = []
    
    init(_ row: Int = 0, _ col: Int = 0, _ initValue: T = 0) {
        self.Row = row
        self.Col = col
        for _ in 0..<row {
            var newLine: [T] = []
            for _ in 0..<col {
                newLine.append(initValue)
            }
            self.Value.append(newLine)
        }
    }
    
    func Create(_ row: Int, _ col: Int) -> Num2D<T> {
        let dst = Num2D(row, col, 0)
        return dst
    }
    func Clone() -> Num2D<T> {
        let dst = self.Create(self.Row, self.Col)
        for m in 0..<self.Row {
            for n in 0..<self.Col {
                dst[m, n] = self[m, n]
            }
        }
        return dst
    }
    
    
    subscript(rowIndex: Int) -> [T] {
        get {
            return self.Value[rowIndex]
        }
        set {
            self.Value[rowIndex] = newValue
        }
    }
    
    subscript(row: Int, col: Int) -> T {
        get {
            return self.Value[row][col]
        }
        set {
            self.Value[row][col] = newValue
        }
    }
    
    ////////////////////////////////////////
    // Convert
    ////////////////////////////////////////
    func ToDouble() throws -> Num2D<Double> {
        let dst = Num2D<Double>(self.Row, self.Col, Double(0.0))
        for m in 0..<dst.Row {
            for n in 0..<dst.Col {
                if let strVal = self[m, n] as? String, let dblVal = Double(strVal) {
                    dst[m, n] = dblVal
                } else {
                    throw Err.Generic("\(#function) in \(#line):  could not convert Double:  \(self[m, n])")
                }
            }
        }
        return dst
    }
    
    func Transpose() -> Num2D<T> {
        let dst = self.Create(self.Col, self.Row)
        for m in 0..<self.Row {
            for n in 0..<self.Col {
                dst[n, m] = self[m, n]
            }
        }
        return dst
    }

    ////////////////////////////////////////
    // Get Value
    ////////////////////////////////////////
    func Line(_ rowIndex: Int) -> Num1D<T> {
        let dst = Num1D(self[rowIndex])
        return dst
    }
    func LineT(_ colIndex: Int) -> Num1D<T> {
        var arr: [T] = []
        for m in 0..<self.Row {
            arr.append(self[m, colIndex])
        }
        let dst = Num1D(arr)
        return dst
    }
    
    ////////////////////////////////////////
    // Index operation
    ////////////////////////////////////////
    func Indexing(_ indexes: Num1D<Int>) -> Num2D<T> {
        let dst = self.Create(indexes.Count, self.Col)
        for i in 0..<indexes.Count {
            dst[i] = self[indexes[i]]
        }
        return dst
    }
    
    func IndexingT(_ indexes: Num1D<Int>) -> Num2D<T> {
        let xT = self.Transpose()
        let dstT = xT.Indexing(indexes)
        let dst = dstT.Transpose()
        return dst
    }
    
    
    ////////////////////////////////////////
    // Caluculation
    ////////////////////////////////////////
    static func - (_ a: Num2D<T>, _ b: Num1D<T>) -> Num2D<T> {
        let n2d = Num2D()
        let answer = n2d.Create(a.Row, a.Col)
        for m in 0..<answer.Row {
            for n in 0..<answer.Col {
                answer[m, n] = a[m, n] - b[n]
            }
        }
        return answer
    }
    
    static func - (_ a: Num2D<T>, _ b: Num2D<T>) -> Num2D<T> {
        let n2d = Num2D()
        let answer = n2d.Create(a.Row, a.Col)
        for m in 0..<answer.Row {
            for n in 0..<answer.Col {
                answer[m, n] = a[m, n] - b[m, n]
            }
        }
        return answer
    }
    
    static func / (_ a: Num2D<T>, _ b: Num1D<T>) -> Num2D<T> {
        let n2d = Num2D<T>()
        let answer = n2d.Create(a.Row, a.Col)
        for m in 0..<answer.Row {
            for n in 0..<answer.Col {
                let n1 = GenericToDouble(a[m, n])
                let n2 = GenericToDouble(b[n])
                WriteGVariable(&answer[m, n], n1 / n2)
            }
        }
        return answer
    }
    
    func Power(_ b: Double) -> Num2D<T> {
        let answer = self.Clone()
        for m in 0..<answer.Row {
            for n in 0..<answer.Col {
                let a = GenericToDouble(answer[m, n])
                WriteGVariable(&answer[m, n], pow(a, b))
            }
        }
        return answer
    }
    
    func Sqrt() -> Num2D<T> {
        let answer = self.Clone()
        for m in 0..<answer.Row {
            for n in 0..<answer.Col {
                let a = GenericToDouble(answer[m, n])
                WriteGVariable(&answer[m, n], sqrt(a))
            }
        }
        return answer
    }
    
    func Total() -> Num1D<T> {
        let total = Num1D<T>(self.Col, 0)
        for m in 0..<self.Row {
            for n in 0..<self.Col {
                total[n] = total[n] + self[m, n]
            }
        }
        return total
    }
    
    func TotalX() -> T {
        var total: T = 0
        for m in 0..<self.Row {
            for n in 0..<self.Col {
                total += self[m, n]
            }
        }
        return total
    }
    
    func Mean() -> Num1D<T> {
        let total = self.Total()
        let answer = total / (Double(self.Row) as! T)
        return answer
    }
    
    func Variance() -> Num1D<T> {
        let mean = self.Mean()
        let subtract = self - mean;
        let power = subtract.Power(2)
        return power.Mean()
    }
}

func Dump2D<T>(_ x: Num2D<T>) -> Void {
    for m in 0..<x.Row {
        for n in 0..<x.Col {
            print(x[m, n], terminator: "")
            if(n < (x.Col - 1)) {
                print(", ", terminator: "")
            }
        }
        print()
    }
}

class TSV {
    enum Err: Error {
        case Generic(String)
    }
    static func Read(_ fileName: String) throws -> [[String]] {
        var rowSize: Int = 0
        var cells: [[String]] = []
        do {
            let csvString = try String(contentsOfFile: fileName, encoding: String.Encoding.utf8)
            let csvLines = csvString.components(separatedBy: .newlines)
            for csvLine in csvLines {
                if(csvLine.count == 0) {
                    continue
                }
                var row: [String] = []
                for col in csvLine.components(separatedBy: "\t") {
                    row.append(col)
                }
                cells.append(row)
                rowSize += 1
            }
        } catch {
            throw Err.Generic("\(error)")
        }
        
        // check
        var colSize = 0
        for row in cells {
            if(colSize == 0) {
                colSize = row.count
            } else if(colSize != row.count) {
                throw Err.Generic("\(#function) in \(#line): mismatch column size:  \(colSize) != \(row.count)")
            }
        }
        
        return cells;
    }
    static func ToDouble(_ src: [[String]]) throws -> Num2D<Double> {
        let rowSize = src.count
        let colSize = src[0].count
        let dst = Num2D<Double>(rowSize, colSize, 0);
        for m in 0..<rowSize {
            for n in 0..<colSize {
                if let dblVal = Double(src[m][n]) {
                    dst[m, n] = dblVal
                } else {
                    throw Err.Generic("\(#function) in \(#line):  could not convert Double:  \(src[m][n])")
                }
            }
        }
        return dst
    }
}

