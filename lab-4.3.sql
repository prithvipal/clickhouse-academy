select count() from s3('https://learn-clickhouse.s3.us-east-2.amazonaws.com/operating_budget.csv')
SETTINGS format_csv_delimiter='~'

select sum(actual_amount) from s3('https://learn-clickhouse.s3.us-east-2.amazonaws.com/operating_budget.csv')
SETTINGS format_csv_delimiter='~'

-- this does not work
select sum(approved_amount) from s3('https://learn-clickhouse.s3.us-east-2.amazonaws.com/operating_budget.csv')
SETTINGS format_csv_delimiter='~'

describe s3('https://learn-clickhouse.s3.us-east-2.amazonaws.com/operating_budget.csv')
SETTINGS format_csv_delimiter='~'

select sum(toUInt32OrZero(approved_amount)), sum(toUInt32OrZero(recommended_amount)) 
from s3('https://learn-clickhouse.s3.us-east-2.amazonaws.com/operating_budget.csv')
SETTINGS format_csv_delimiter='~'

select 
    formatReadableQuantity(sum(approved_amount)), 
    formatReadableQuantity(sum(recommended_amount))
from s3('https://learn-clickhouse.s3.us-east-2.amazonaws.com/operating_budget.csv')
SETTINGS 
format_csv_delimiter='~',
schema_inference_hints='approved_amount UInt32, recommended_amount UInt32';

SELECT 
    formatReadableQuantity(sum(toUInt32OrZero(approved_amount))),
    formatReadableQuantity(sum(toUInt32OrZero(recommended_amount)))
FROM s3('https://learn-clickhouse.s3.us-east-2.amazonaws.com/operating_budget.csv')
SETTINGS 
format_csv_delimiter='~',
schema_inference_hints='approved_amount UInt32, recommended_amount UInt32';

describe s3('https://learn-clickhouse.s3.us-east-2.amazonaws.com/operating_budget.csv')
SETTINGS format_csv_delimiter='~',
schema_inference_make_columns_nullable=false

select fund_type from s3('https://learn-clickhouse.s3.us-east-2.amazonaws.com/operating_budget.csv') limit 10
SETTINGS format_csv_delimiter='~' 

create table operating_budget
(
fiscal_year	LowCardinality(String),
service	LowCardinality(String),
department	LowCardinality(String),
program	LowCardinality(String),
description	String,
item_category	LowCardinality(String),
approved_amount	UInt32,
recommended_amount	UInt32,
actual_amount	Decimal(12,2),
fund	LowCardinality(String),
fund_type	Enum('GENERAL FUNDS'=0, 'FEDERAL FUNDS'=1, 'OTHER FUNDS'=2),
program_code LowCardinality(String)
)
ENGINE=MergeTree
PRIMARY KEY (fiscal_year, program)
SETTINGS format_csv_delimiter='~' 

insert into operating_budget
select 
    fiscal_year,
    service,
    department,
    splitByChar('(', program_full)[1] as program,
    description,
    item_category,
    toUInt32OrZero(approved_amount),
    toUInt32OrZero(recommended_amount),
    toDecimal64(actual_amount, 2),
    fund,
    CAST(fund_type AS Enum8('GENERAL FUNDS' = 0, 'FEDERAL FUNDS' = 1, 'OTHER FUNDS' = 2)) AS fund_type,
    trimRight(replaceRegexpOne(program_full, '.*\\((\\d+)\\)', '\\1')) AS program_code
from 
    s3(
        'https://learn-clickhouse.s3.us-east-2.amazonaws.com/operating_budget.csv', 
        'CSV',
        'fiscal_year String,
        service String,
        department String,
        program_full String,
        description String,
        item_category String,
        approved_amount	String,
        recommended_amount	String,
        actual_amount	String,
        fund String,
        fund_type String
        '
    )
settings
input_format_csv_skip_first_lines=1,
format_csv_delimiter='~'

select * from operating_budget limit 10

select avg(approved_amount) from operating_budget where fiscal_year='2021'

select sum(actual_amount) from operating_budget where program_code='031' and fiscal_year='2022'
