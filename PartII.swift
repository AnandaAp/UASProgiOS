//Data Class untuk mengimplementasikan Prototype DP
class Barang: Codable{
    private var jenis: String
    private var kategori: String
    private var merk: String
    private var harga: Double
    private var expiredDate: String
    init(jenis: String = "",
        kategori: String = "",
        merk: String = "", 
        harga: Double = 0, 
        expiredDate: String = ""
        ){
        self.jenis = jenis
        self.kategori = kategori
    }
    fun clone() -> Barang{
        return Barang(jenis: self.jenis, kategori: self.kategori)
    }
}

class Susu: Barang {
    private var merk: String
    private var harga: Double
    private var expiredDate: String
    init(merk: String = "", harga: Double = 0, expiredDate: String = ""){
        self.merk = merk
        self.harga = harga
        self.expiredDate = expiredDate
    }
    override fun clone() -> Susu{
        return Susu(merk: self.merk, harga: self.harga, expiredDate: self.expiredDate)
    }
}

class Kopi: Barang {
    private var merk: String
    private var harga: Double
    private var expiredDate: String
    init(merk: String = "", harga: Double = 0, expiredDate: String = ""){
        self.merk = merk
        self.harga = harga
        self.expiredDate = expiredDate
    }
    override func clone() -> Kopi{
        return Kopi(merk: self.merk, harga: self.harga, expiredDate: self.expiredDate)
    }
}

//Data Class untuk mengambil data dari DB
class BarangDB: Codable{
    let jenis: String?
    let kategori: String?
    let merk: String?
    let harga: Double?
    let expiredDate: String?
}

/*
//class for DB layer
class DBHelper{
    var db : OpaquePointer?
    var path : String
    init(path: String) {
        self.path = path
        self.db = createDB()
        self.createTable()
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
            
        var db : OpaquePointer? = nil
            
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
        print("There is error in creating DB")
        return nil
        }
        else {
        print("Database has been created with path \(path)")
        return db
        }
    }

    func createTable(query: String)  {
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
        if sqlite3_step(statement) == SQLITE_DONE {
            print("Table creation success")
        }
        else {
            print("Table creation fail")
        }
        } 
        else {
        print("Prepration fail")
        }
    }
    func insert(query: String) {
        var statement : OpaquePointer? = nil    
        var isEmpty = false 
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
        if sqlite3_step(statement) == SQLITE_DONE {
            print("Data inserted success")
        }
        else {
            print("Data is not inserted in table")
        }
        } 
        else {
        print("Query is not as per requirement")
        }      
    }
    
    func readSusu(query: String) -> Susu {
        var merk: String
        var harga: Double
        var expiredDate: String
        var statement : OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let merkDB = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let hargaDB = Double(sqlite3_column_int(statement, 1))
                let expiredDateDB = String(describing: String(cString: sqlite3_column_text(statement, 2)))
            }
        }
        return Susu(merk,harga,expiredDate)
    }

    func readKopi(query: String) -> Susu {
        var merk: String
        var harga: Double
        var expiredDate: String
        var statement : OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let merkDB = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let hargaDB = Double(sqlite3_column_int(statement, 1))
                let expiredDateDB = String(describing: String(cString: sqlite3_column_text(statement, 2)))
            }
        }
        return Kopi(merk,harga,expiredDate)
    }

    func delete(table: String,id : Int) {
        let query = "DELETE FROM \(table) where id = \(id)"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
        if sqlite3_step(statement) == SQLITE_DONE {
            print("Data delete success")
        }
        else {
            print("Data is not deleted in table")
        }
        }
    }
    func update(query: String) {
            var statement : OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Data updated success")
                }else {
                    print("Data is not updated in table")
                }
            }
        }
}
*/

//Controller Layer
class ViewController: UIViewController{
    // View from the storyboard - both labels
    @IBOutlet var merk: UILabel!
    @IBOutlet var harga: UILabel!
    @IBOutlet var expiredDate: UILabel!
    //variable untuk data
    private var barangDB: [BarangDB]
    private var barang: [Barang]

    // Controller continued
    override func viewDidLoad() {
        super.viewDidLoad()
        let susu: Susu()
        let kopi: Kopi

        //mengambil data json dari internet
        loadData()

        //memindahkan data dari Data Class DB ke Data Class barang
        for item in barangDB {
            let jenisInit = barangDB[item].jenis
            let kategoriInit = barangDB[item].kategori
            let hargaInit = barangDB[item].harga
            let merkInit = barangDB[item].merk
            let expiredDateInit = barangDB[item].expiredDate
            barangDB.append(Barang(jenisInit,kategoriInit,merkInit,hargaInit,expiredDateInit))
        }

        for item in barangDB {
            if barang[item].jenis.caseInsensitiveCompare("kopi") == ComparisonResult.orderedSame {
                let kopiView = kopi.clone()
                kopiView.merk = barang[item].merk
                kopiView.harga = barang[item].harga
                kopiView.expiredDate = barang[item].expiredDate
                
                //menampilkan di element view
                merk.text = kopiView.merk
                harga.text = kopiView.harga
                expiredDate.text = kopiView.expiredDate
            }
            else if barangDB[item].jenis.caseInsensitiveCompare("susu") == ComparisonResult.orderedSame {
                let susuView = susu.clone()
                susuView.merk = barang[item].merk
                susuView.harga = barang[item].harga
                susuView.expiredDate = barang[item].expiredDate

                //menampilkan di element view
                merk.text = susuView.merk
                harga.text = susuView.harga
                expiredDate.text = susuView.expiredDate
            }
        }
    }

    func loadData(){
        NetworkManager.fetchData(barang)
    }
}

//class for network layer
class NetworkManager{
    func fetchData(completion: @escaping(_ barang: [BarangDB]) -> Void){
        guard let url= URL(string: "json url link here"){
            return
        }

        URLSession.shared.dataTask(with: url){ data, response, error in
            println("Data",data)
            println("Response",response)
            // let jsonData = data.data(using: .utf8)!
            if let jsonString = String(data: data!, encoding: .utf8) {
                print(jsonString)
            }
            let barang: [BarangDB] = try! JSONDecoder().decode([BarangDB].self, from : data!)
                completion(barang)
        }
        .resume()
    }
}