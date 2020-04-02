//
//  FMDBWrapper.swift
//  reciteVocabularyApp
//
//  Created by Richard Chui on 2020/2/24.
//  Copyright © 2020 Richard Technology (Shezhen)  Co., Ltd. All rights reserved.
//

import Cocoa
import FMDB

class DB: NSObject {
    //单例
    static let share = DB()
    
    //定义管理数据库的对象
    //var db: FMDatabase!
    var db1: FMDatabaseQueue!
    //线程锁,通过加锁和解锁来保证所做操作数据的安全性
    let lock = NSLock()
    
    /**
     *1.重写父类的构造方法
     */
    override init() {
        super.init()
        //设置数据库的路径;fmdb.sqlite是由自己随意命名
        let path = NSTemporaryDirectory().appending("library.db")

        //构造管理数据库的对象
        //db = FMDatabase(path: path)
        db1 = FMDatabaseQueue(path: path)
        //判断数据库是否打开成功;如果打开失败则需要创建数据库
//        if !db.open() {
//            return
//        }
    }
    
    func isEmpty(table: String) -> Bool {
        // 查看表是否存在和为空
        var bool = false
        db1.inTransaction { (db, rollback) in
            let result = db.executeQuery("SELECT COUNT(*) FROM \(table)", withArgumentsIn: [])
            if result == nil {
                bool = true
            }else{
                if result!.next() {
                   let count = result!.int(forColumnIndex: 0)
                    if count > 0 {
                        bool = false
                    } else {
                        bool = true
                    }
                } else {
                    bool = true
                }
            }
        }
        return bool
    }
    
    /*****************************1.创建表********************************/
    func create(table: String) {
        //创建数据表
        //dhtable表达表名，由自己命名
        //varchar表示字符串，integer表示数字，primary表示自增,key 表示主键
        //执行sel语句进行数据库的创建
        db1.inTransaction { (db, rollback) in
            let createSql = "CREATE TABLE IF NOT EXISTS \(table) (dhkey varchar(100),dhvalue varchar(100))"
            do {
                try db.executeUpdate(createSql, values: nil)
            }catch {
                print(db.lastErrorMessage())
            }
        }
    }
    
    /*****************************2.增加一条数据********************************/
    func insertDataWith(table: String, dhvalue:String, dhkey:String) {
        //加锁操作
        //lock.lock()
        //sel语句
        //(?,?)表示需要传的值，对应前面出现几个字段，后面就有几个问号
        //更新数据库
        db1.inTransaction { (db, rollback) in
            let insetSql = "insert into \(table)(dhkey , dhvalue) values(?,?)"
            do {
                try db.executeUpdate(insetSql, values: [dhkey,dhvalue])
            }catch {
                print(db.lastErrorMessage())
            }
        }
        //解锁
        //lock.unlock()
        
    }
    
    /*****************************2.增加一个字段********************************/
    func insertFieldWith(table: String, newField:String) {
        db1.inTransaction { db, rollback in
        if !(db.columnExists(newField, inTableWithName: "dhtable")) {
            let addSql = "alter table \(table) add integer " + newField
            do {
                try db.executeUpdate(addSql, values: nil)
            }catch {
                print(db.lastErrorMessage())
            }
        }
        }
    }
    
    /*****************************3.删********************************/
    func deleteDataWith(table: String, dhkey:String) {
        db1.inTransaction{ db, rollback in
        //sel语句
        //where表示需要删除的对象的索引，是对应的条件
        let deleteSql = "delete from \(table) where dhkey = ?"
        //更新数据库
        do{
            try db.executeUpdate(deleteSql, values: [dhkey])
        }catch {
            print(db.lastErrorMessage())
        }
            
    }
    }
    
    func drop(table: String) {
        
        db1.inTransaction{ db, rollback in
        //where表示需要删除的对象的索引，是对应的条件
        let dropSql = "drop table \(table)"
        //更新数据库
        do{
            try db.executeUpdate(dropSql, values: nil)
        }catch {
            print(db.lastErrorMessage())
        }
    }
    }
    
    /*****************************4.改********************************/
    func updateDataWith(table: String, dhvalue:String, dhkey:String) {
        db1.inTransaction { db, rollback in
        if DB.share.isHasDataInTable(table: table, dhkey: dhkey) {
            lock.lock()
            // 判断是否存在 存在即修改 不存在即插入
            let updateSql = "update \(table) set dhvalue = ? where dhkey = ?"
            //更新数据库
            do{
                try db.executeUpdate(updateSql, values: [dhvalue,dhkey])
            }catch {
                print(db.lastErrorMessage())
            }
            //解锁
            lock.unlock()
        }else{
            DB.share.insertDataWith(table: table, dhvalue: dhvalue, dhkey: dhkey)
        }
        }
    }
    
    /********5.判断数据库中是否有当前数据(查找一条数据)*********************/
    func isHasDataInTable(table: String, dhkey:String) -> Bool {
        var bool = true
        db1.inTransaction { db, rollback in
                let isHas = "select * from \(table) where dhkey = ?"
                do{
                    let set = try db.executeQuery(isHas, values: [dhkey])
                    //查找当前行，如果数据存在，则接着查找下一行
                    if set.next() {
                        bool = true
                    }else {
                        bool = false
                    }
                }catch {}
        }
        
        
        return bool
        
    }
    
    /********6.根据条件查找数据*********************/
    func countRow(table: String) -> Int {
        var count = 0
        db1.inTransaction { db, rollback in
            let sql = "select count(*) from \(table)"
            do {
                let set = try db.executeQuery(sql, values: nil)
                if set.next() {
                    count = Int(set.int(forColumnIndex: 0))
                }
            }catch{}
        }
        return count
    }
    
    
    
    func fetchAllData(table: String, dhkey:String) ->([String]){
        var tempArray = [String]()
        db1.inTransaction { db, rollback in
        
        let fetchSql = "select * from \(table) where dhkey = ?"
        //用于符合条件数据的临时数组
        
        do {
            let set = try db.executeQuery(fetchSql, values: [dhkey])
            //循环遍历结果
            while set.next() {
                var dhvalue = String()
                //给字段赋值
                dhvalue = set.string(forColumn: "dhvalue")!
                tempArray.append(dhvalue)
            }
        }catch {
            print(db.lastErrorMessage())
        }
        
        }
        
        return (tempArray)
    }
    
    func fetchAllData(table: String) ->([String],[String]){
        var dhvalueArray = [String]()
        var dhkeyArray = [String]()
        
        db1.inTransaction { (db, rollback) in
        let fetchSql = "select * from \(table)"
        //用于承接所有数据的临时数组
        
        do {
            let set = try db.executeQuery(fetchSql, values: nil)
            //循环遍历结果
            while set.next() {
                var dhvalue = String()
                var dhkey = String()
                //给字段赋值
                dhvalue = set.string(forColumn: "dhvalue") ?? ""
                dhkey = set.string(forColumn: "dhkey") ?? ""
                dhvalueArray.append(dhvalue)
                dhkeyArray.append(dhkey)
                
            }
        }catch {
            print(db.lastErrorMessage())
        }
        }
        return (dhvalueArray,dhkeyArray)
    }
    
    func fetchTwentyData(table: String) -> [(chinese: String,english: String)] {
        var result = [(String,String)]()
        db1.inTransaction { (db, rollback) in
        let fetchSql = "select * from \(table) order by random() limit 20"
        do {
            let set = try db.executeQuery(fetchSql, values: nil)
            //循环遍历结果
            while set.next() {
                var dhvalue = String()
                var dhkey = String()
                //给字段赋值
                dhvalue = set.string(forColumn: "dhvalue") ?? ""
                dhkey = set.string(forColumn: "dhkey") ?? ""
                result.append((chinese: dhkey, english: dhvalue))
                
            }
        }catch {
            print(db.lastErrorMessage())
        }
        
        }
        return result
    }
    
    func fetchThreeData(table: String) -> [String] {
        
        var result = [String]()
        db1.inTransaction{ (db, rollback) in
        let fetchSql = "select dhkey from \(table) order by random() limit 3"
        do {
            let set = try db.executeQuery(fetchSql, values: nil)
            //循环遍历结果
            while set.next() {
                //var dhvalue = String()
                var dhkey = String()
                //给字段赋值
                //dhvalue = set.string(forColumn: "dhvalue") ?? ""
                dhkey = set.string(forColumn: "dhkey") ?? ""
                result.append(dhkey)
                
            }
        }catch {
            print(db.lastErrorMessage())
        }
            
        }
        return result
    }
               
    func fetchLikeData(table: String, keyword: String) -> [(String,String)] {
        var result = [(String,String)]()
        db1.inTransaction{ (db, rollback) in
        
        var fetchSql = "select * from \(table) where"
        
        let split = keyword.split(separator: " ")
        for (index, s) in split.enumerated() {
            fetchSql += " dhvalue like '%\(s)%'"
            if index < split.count-1 {
                fetchSql += " and"
            }
        }
        
        if keyword.count == 1 {
            fetchSql = "select * from \(table) where dhvalue like '\(keyword)%'"
        }
        

        
        do {
            let set = try db.executeQuery(fetchSql, values: nil)
            //循环遍历结果
            while set.next() {
                var dhvalue = String()
                var dhkey = String()
                //给字段赋值
                dhvalue = set.string(forColumn: "dhvalue") ?? ""
                dhkey = set.string(forColumn: "dhkey") ?? ""
                result.append((chinese: dhkey, english: dhvalue))
                
            }
        }catch {
            print(db.lastErrorMessage())
        }
        }
        return result
    }

    
}
