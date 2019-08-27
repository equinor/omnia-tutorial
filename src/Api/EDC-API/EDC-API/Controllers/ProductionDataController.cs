using System.Collections.Generic;
using System.Linq;
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

        // GET: production-data
        [HttpGet]
        public ActionResult<IEnumerable<ProductionData>> GetList(string searchString)
        {
            var productionDataQueryable = _context.ProductionData.AsQueryable();

            if (!string.IsNullOrEmpty(searchString))
            {
                productionDataQueryable = productionDataQueryable
                    .Where(pa => pa.Wellbore.Contains(searchString) || pa.Year.ToString().Contains(searchString));
            };

            return productionDataQueryable.ToList();
        }

        // GET: production-data/5
        [HttpGet("{id}")]
        public ActionResult<ProductionData> Get(int id)
        {
            var productionData =  _context.ProductionData.Find(id);

            if (productionData == null)
            {
                return NotFound();
            }

            return productionData;
        }

        // PUT: production-data/5
        [HttpPut("{id}")]
        public IActionResult Put(int id, ProductionData productionData)
        {
            if (id != productionData.Id)
            {
                return BadRequest();
            }

            _context.Update(productionData);

            try
            {
                _context.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProductionDataExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: production-data
        [HttpPost]
        public ActionResult<ProductionData> Post(ProductionDataRequest request)
        {
            _context.ProductionData.Add(request);

            try
            {
                _context.SaveChanges();
            }
            catch (DbUpdateException)
            {
                    throw;
            }

            var productionData = _context.ProductionData.Last();

            return CreatedAtAction("GetProductionData", productionData);
        }

        // DELETE: production-data/5
        [HttpDelete("{id}")]
        public ActionResult<ProductionData> Delete(int id)
        {
            var productionData = _context.ProductionData.Find(id);
            if (productionData == null)
            {
                return NotFound();
            }

            _context.ProductionData.Remove(productionData);
            _context.SaveChanges();

            return productionData;
        }

        // GET: production-data/between-dates
        [HttpGet("between-dates")]
        public ActionResult<IEnumerable<ProductionData>> GetListBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var productionDataQueryable = _context.ProductionData.AsQueryable();

            if (fromYear != null)
            {
                productionDataQueryable = productionDataQueryable.Where(pa => pa.Year >= fromYear);
            }
            if (toYear != null)
            {
                productionDataQueryable = productionDataQueryable.Where(pa => pa.Year <= toYear);
            }
            if (fromMonth != null)
            {
                productionDataQueryable = productionDataQueryable.Where(pa => pa.Month >= fromMonth);
            }
            if (toMonth != null)
            {
                productionDataQueryable = productionDataQueryable.Where(pa => pa.Month <= toMonth);
            }

            return productionDataQueryable.ToList();
        }

        private bool ProductionDataExists(int id)
        {
            return _context.ProductionData.Any(e => e.Id == id);
        }
    }
}
