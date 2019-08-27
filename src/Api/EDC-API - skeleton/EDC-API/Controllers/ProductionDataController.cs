using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using EDC_API.Data;
using EDC_API.Models;

namespace EDC_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductionDatasController : ControllerBase
    {
        private readonly CommonDbContext _context;

        public ProductionDatasController(CommonDbContext context)
        {
            
            _context = context;
        }

        // GET: api/ProductionDatas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ProductionData>>> GetProductionData()
        {
            // TODO Use the CommonDbContext to retrieve all entries from the ProductionData table

            throw new NotImplementedException();
            
        }

        // GET: api/ProductionDatas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ProductionData>> GetProductionData(int id)
        {
            // TODO Retrieve a single entry with the specified Id.


            throw new NotImplementedException();
        }

        // PUT: api/ProductionDatas/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProductionData(int id, ProductionData productionData)
        {

            // TODO Update a ProductionData entry

            throw new NotImplementedException();
        }

        // POST: api/ProductionDatas
        [HttpPost]
        public async Task<ActionResult<ProductionData>> PostProductionData(ProductionDataRequest request)
        {

            // TODO Add new entry to the database

            throw new NotImplementedException();
        }

        // DELETE: api/ProductionDatas/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<ProductionData>> DeleteProductionData(int id)
        {
            // TODO Delete existing entry from the database.

            throw new NotImplementedException();
        }

        private bool ProductionDataExists(int id)
        {
            return _context.ProductionData.Any(e => e.Id == id);
        }
    }
}
