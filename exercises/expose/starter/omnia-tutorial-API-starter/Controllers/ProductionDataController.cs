using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using omnia_tutorial.Data;
using omnia_tutorial.Models;

namespace omnia_tutorial.Controllers
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
            var productionDatas = _context.ProductionData.Where(f => f.Wellbore.Contains(search)).ToList();

            return Ok(productionDatas);
        }

        // GET: production-data/5
        [HttpGet("{id}")]
        public ActionResult<ProductionData> Get(int id)
        {
            var productionData = _context.ProductionData.FirstOrDefault(f => f.Id == id);
            return Ok(productionData);
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
