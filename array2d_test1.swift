
class Piyo {
    var Count: Int = 4
    var Value: [Int] = []
    func Arange(_ start: Int, _ end: Int) -> Piyo {
        let count: Int = end - start
        var dst = Piyo()
        for i in 0..<count {
            dst.Value.append(start + i)
        }
        return dst
    }
    subscript(index: Int) -> Int {
        get {
            return self.Value[index]
        }
        set {
            self.Value[index] = newValue
        }
    }
}

func DumpPiyo(_ p: Piyo) {
    for i in 0..<p.Count {
        print(p[i], terminator: "")
        if(i < (p.Count - 1)) {
            print(", ", terminator: "")
        }
    }
    print()
}

class Hoge {
    var Row: Int = 3
    var Col: Int = 4
    var Value: [Piyo] = []
    func Test1() {
        let piyo = Piyo()
        self.Value = [
            piyo.Arange(0, 10),
            piyo.Arange(0, 10),
            piyo.Arange(0, 10),
            piyo.Arange(0, 10),
        ]
    }
    subscript(rowIndex: Int) -> Piyo {
        get {
            return self.Value[rowIndex]
        }
//        set {
//            self.Value[row][col] = newValue
//        }
    }
}

func DumpHoge(_ h: Hoge) {
    for i in 0..<h.Row {
        DumpPiyo(h[i])
    }
}

func Test1D() {
    var a = Hoge()
    a.Test1()
    print("a[2, 1]", a[2][1])
    print(a.Value)
    
    DumpHoge(a)
    a[2][1] = 999
    DumpHoge(a)
    //let n1d = Num1D()
    //let x1 = Num1D.Full(10, 1.0)
    //print(x1)
}

Test1D()
