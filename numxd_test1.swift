


import Foundation

class Num1D {
    static func Full(_ count: Int, _ value: Any) -> [Any] {
        return Array(repeating: value, count: count)
    }
    static func Arange(_ start: Int, _ end: Int) -> [Int] {
        let count = end - start
        var response: [Int] = []
        for i in 0..<count {
            response.append(start + i)
        }
        return response
    }
}

class Num2D {
    enum Err: Error {
        case Generic(String)
    }
    static func Full(_ row: Int, _ col: Int, _ value: Any) -> [[Any]] {
        return Array(repeating: Array(repeating: value, count: col), count: row)
    }
    static func ToDouble(_ X: [[Any]]) throws -> [[Double]] {
        var response: [[Double]] = []
        for row in X {
            var newRow: [Double] = []
            for val in row {
                if let dblStr = val as? String, let dblVal = Double(dblStr) {
                    newRow.append(dblVal)
                } else {
                    throw Err.Generic("\(#function) in \(#line):  could not convert Double:  \(val)")
                }
            }
            response.append(newRow)
        }
        return response
    }
    
    static func Transpose(_ x: [[Any]]) -> [[Any]] {
        var response = self.Full(x[0].count, x.count, x[0][0])
        for m in 0..<x.count {
            for n in 0..<x[0].count {
                response[n][m] = x[m][n]
            }
        }
        return response
    }
    
    static func Indexing(_ x: [[Any]], _ indexes: [Int]) -> [[Any]] {
        var response: [[Any]] = []
        for i in indexes {
            response.append(x[i])
        }
        return response
    }
    
    static func IndexingT(_ x: [[Any]], _ indexes: [Int]) -> [[Any]] {
        let xT = self.Transpose(x)
        let responseT = self.Indexing(xT, indexes)
        return self.Transpose(responseT)
    }
}



class TSV {
    enum Err: Error {
        case Generic(String)
    }
    static func Read(_ fileName: String) throws -> [[String]] {
        var response: [[String]] = []
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
                response.append(row)
            }
        } catch {
            throw Err.Generic("\(error)")
        }
        
        // check
        var column = 0
        for row in response {
            if(column == 0) {
                column = row.count
            } else if(column != row.count) {
                throw Err.Generic("\(#function) in \(#line): mismatch column size:  \(column) != \(row.count)")
            }
        }
        
        return response
    }
}

func Test1D() {
    //let n1d = Num1D()
    let x1 = Num1D.Full(10, 1.0)
    print(x1)
}

func Test2D() {
    do {
        let tsvData = try TSV.Read("seeds_dataset.txt")
        var data = try Num2D.ToDouble(tsvData)
        let indexes = Num1D.Arange(0, 7)
        let xData = Num2D.IndexingT(data, indexes)
        print(xData)
    } catch {
        print("exception", error)
    }
}

func main() {
    //Test1D()
    Test2D()
}

main()
