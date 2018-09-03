using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess;

using Amazon.Lambda.Core;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]

namespace AWSLambda1
{
    public class Function
    {        
        /// <summary>
        /// A simple function that takes a string and does a ToUpper
        /// </summary>
        /// <param name="input"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public string GetStringFromDB(string input, ILambdaContext context)
        {
             Oracle.ManagedDataAccess.Client.OracleConnection _con = new Oracle.ManagedDataAccess.Client.OracleConnection();
             string connectionString = "";
             connectionString = "Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=lattuceorcl.cdbrh6uczknc.eu-west-1.rds.amazonaws.com)(Port=1521))(CONNECT_DATA=(SID=orcl)));User Id=davidken;Password=DefaultPwd;Persist Security Info=True;";
             _con.ConnectionString = connectionString;
             _con.Open();


             Oracle.ManagedDataAccess.Client.OracleCommand cmd = _con.CreateCommand();
             cmd.CommandText = "SELECT test_column FROM test_table";
             string val = cmd.ExecuteScalar().ToString();

             return val;
        }
    }
}
