
import Foundation

// https://academy.realm.io/jp/posts/richard-fox-casting-swift-2/
// https://qiita.com/ObuchiYuki/items/a945efd14d3a05a19f75

func ToDouble<T: Numeric>(_ n: T) -> Double {
    switch T.self {
        case is Int.Type:
            print("Type Int")
            return Double(n as! Int)
        case is Double.Type:
            print("Type Double")
            return Double(n as! Double)
        default:
            print("Type Unknown")
            return Double(n as! Int)
    }
}

func ToInt<T: Numeric>(_ n: T) -> Int {
    switch T.self {
        case is Int.Type:
            print("Type Int")
            return Int(n as! Int)
        case is Double.Type:
            print("Type Double")
            return Int(n as! Double)
        default:
            print("Type Unknown")
            return Int(n as! Int)
    }
}


func Substitution<T: Numeric, U: Numeric>(_ dst: inout T, _ src: U) {
    let srcDbl = ToDouble(src)
    if T.self is Double.Type {
        dst = srcDbl as! T
    } else if T.self is Int.Type {
        dst = Int(srcDbl) as! T
    }
}

func PiyoPiyo<T: Numeric, U: Numeric>(_ a: inout T, _ b: U) {
    Substitution(&a, b)
}

func main() ->Void {
    //Test1()
    //Test2()
    var arr: [Double] = [1, 2, 3]
    print(arr)
    PiyoPiyo(&arr[1], Double(9))
    print(arr)
}

main()
