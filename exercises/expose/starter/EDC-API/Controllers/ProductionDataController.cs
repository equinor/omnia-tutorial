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
    [Route("production-data")]
    [ApiController]
    public class ProductionDataController : ControllerBase
    {
        private readonly CommonDbContext _context;

        public ProductionDataController(CommonDbContext context)
        {

            _context = context;
        }

        // GET: production-data?search=<searchString>
        [HttpGet]
        public ActionResult<IEnumerable<ProductionData>> GetList(string search)
        {
            // TODO Use the CommonDbContext to retrieve all entries from the ProductionData table

            throw new NotImplementedException();
        }

        // GET: production-data/5
        [HttpGet("{id}")]
        public ActionResult<ProductionData> Get(int id)
        {
            // TODO Retrieve a single entry with the specified Id.
            throw new NotImplementedException();
        }

        // PUT: production-data/5
        [HttpPut("{id}")]
        public IActionResult Put(int id, ProductionData productionData)
        {
            // TODO Update a ProductionData entry
            throw new NotImplementedException();
        }

        // POST: production-data
        [HttpPost]
        public ActionResult<ProductionData> Post(ProductionDataRequest request)
        {
            // TODO Add new entry to the database
            throw new NotImplementedException();
        }

        // DELETE: production-data/5
        [HttpDelete("{id}")]
        public ActionResult<ProductionData> Delete(int id)
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
