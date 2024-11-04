using System.Data.SqlClient;
using Dapper;

namespace TestProject2
{
    public class IntegrationTests
    {
        private const string ConnectionString = "Server=localhost,9595;Database=owl;User Id=SA;Password=Password123456789;TrustServerCertificate=True;";

        [Fact]
        public void TestInsertOrderLine_TriggerUpdatesTotalAmount()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    // Arrange
                    var orderId = 1;
                    var itemId = 1;
                    var quantity = 1;

                    // Act
                    var insertOrderLineQuery = @"
                        INSERT INTO OrderLine (Id, OrderId, ItemId, Quantity) 
                        VALUES (@Id, @OrderId, @ItemId, @Quantity)";
                    connection.Execute(insertOrderLineQuery, new { Id = 3, OrderId = orderId, ItemId = itemId, Quantity = quantity }, transaction);

                    // Assert
                    var totalAmount = connection.QuerySingle<decimal>("SELECT TotalAmount FROM Order1 WHERE Id = @OrderId", new { OrderId = orderId }, transaction);
                    Assert.Equal(24.40m, totalAmount); // Expected total amount after inserting order line
                    transaction.Rollback(); // Rollback the transaction
                }
            }
        }
    }
}