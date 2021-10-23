# term查询

- term query: 会去倒排索引中寻找确切的term，它并不知道分词器的存在。这种查询适合keyword 、numeric、date
- term：查询某个字段为该关键词的文档（它是相等关系而不是包含关系）
- term是代表完全匹配，即不进行分词器分析，必须全值匹配。查询不会对查询的字段进行分词查询，会采用精确匹配
- 可以用它处理数字（numbers）、布尔值（Booleans）、日期（dates）以及文本（text）

## 语法

如果字段类型为text，那么在插入的时候就会被分词，如果使用term查询的话，那么无法命中

```bash
GET /index_name/types_name/_search       
{
  "query": {
    "term": {
        "key": "value" 
      }
    }
}
```

# match查询

知道分词器的存在，会对filed进行分词操作，然后再查询

无论你在任何字段上进行的是全文搜索还是精确查询，`match` 查询是你可用的标准查询。

如果你在一个全文字段上使用 `match` 查询，在执行查询前，它将用正确的分析器去分析查询字符串：

匹配（Match）查询属于全文（Fulltext）查询，不同于词条查询，ElasticSearch引擎在处理全文搜索时，首先分析（analyze）查询字符串，然后根据分词构建查询，最终返回查询结果。匹配查询共有三种类型，分别是布尔（boolean）、短语（phrase）和短语前缀（phrase_prefix），默认的匹配查询是布尔类型，这意味着，ElasticSearch引擎首先分析查询字符串，根据分析器对其进行分词。

## match_all

 查询所有文档

### 语法

```bash
GET index_name/_search
{
    "query":{
    	"match_all": {}
    }
}
```

## match精确匹配

如果在一个精确值的字段上使用它，例如数字、日期、布尔或者一个 `not_analyzed`(version:5) ,keyword(7)字符串字段，那么它将会精确匹配给定的值

### 语法

查询结果是所有年龄=18岁的

```bash
GET userinfo/_search
{
    "query":{
    	"match":{"age": 18}
    }
}
```

## match分词匹配

match query: 知道分词器的存在，会对key的value进行分词操作，然后再查询

```bash
get /index_name/_search  
{
  "query":{
    "match": {
      "key": "value"  
    }
  }
}
```

## multi_match

会对value进行分词，然后再key1和key2两个字段的value中进行匹配

```bash
GET index_name/_search
{
  "query":{
    "multi_match": {
      "query": "value",
      "fields":["key1","key2"]
    }
  }
}
```

## match_phrase

短语匹配查询，ElasticSearch引擎首先分析（analyze）查询字符串，从分析后的文本中构建短语查询，这意味着必须匹配短语中的所有分词，并且保证各个分词的相对位置不变

```bash
GET index_name/_search
{
  "query":{
    "match_phrase":{"key": "value"}
  }
}
```

## 指定返回的字段

可以指定查询结果返回的字段，相当于MySQL中的`select uid,uname from user`

```bash
GET index_name/_search
{
  "_source":["key1","key2"],
}
```

## 排序查询

```bash
GET /index_name/_search
{
	"query":{
		"match_all":{
			
		}
    },
    "sort":{
        "key":{
        "order":"desc[降序]|asc[升序]"
        }
    }
}
```

# 复合查询

bool （布尔）过滤器。 这是个复合过滤器（compound filter） ，它可以接受多个其他过滤器作为参数，并将这些过滤器结合成各式各样的布尔（逻辑）组合。 用户合并其他查询语句，比如一个`bool`语句，允许你在需要的时候组合其他语句，包括`must`，`must_not`，`should`和`filter`语句（多条件组合查询）

## 格式

一个 bool 过滤器由四部分组成

```bash
{
    "query":{
        "bool":{
            "must":[
            ],
            "should":[
            ],
            "must_not":[
            ],
            "filter":[
            ]
        }
    }
}
```

- must
  - 所有的语句都 必须（must） 匹配，与 AND 等价。 
- must_not
  - 所有的语句都 不能（must not） 匹配，与 NOT 等价。
- should
  - 至少有一个语句要匹配，与 OR 等价

## 使用举例

查询userinfo中年龄是18随，且姓名不是lucy的信息

```bash
GET /userinfo/_search
{
    "query": {
        "bool": {
            "must": [
            	{	
                    "match": {
                    	"age": "18"
                    }
                }
            ],
            "must_not": [
                { 
                    "match": { 
                    	"name": "lucy" 
                    } 
                }
            ]
        }
    }
}
```

