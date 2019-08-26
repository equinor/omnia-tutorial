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
            return await _context.ProductionData.ToListAsync();
        }

        // GET: api/ProductionDatas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ProductionData>> GetProductionData(int id)
        {
            var productionData = await _context.ProductionData.FindAsync(id);

            if (productionData == null)
            {
                return NotFound();
            }

            return productionData;
        }

        // PUT: api/ProductionDatas/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProductionData(int id, ProductionData productionData)
        {
            if (id != productionData.Id)
            {
                return BadRequest();
            }

            _context.Entry(productionData).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
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

        // POST: api/ProductionDatas
        [HttpPost]
        public async Task<ActionResult<ProductionData>> PostProductionData(ProductionDataRequest request)
        {
            _context.ProductionData.Add(new ProductionData
            {
                Gas = request.Gas,
                Oil = request.Oil,
                Month = request.Month,
                Wellbore = request.Wellbore,
                Year = request.Year
            });

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                    throw;
            }

            var productionData = _context.ProductionData.Last();

            return CreatedAtAction("GetProductionData", new { id = productionData.Id }, productionData);
        }

        // DELETE: api/ProductionDatas/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<ProductionData>> DeleteProductionData(int id)
        {
            var productionData = await _context.ProductionData.FindAsync(id);
            if (productionData == null)
            {
                return NotFound();
            }

            _context.ProductionData.Remove(productionData);
            await _context.SaveChangesAsync();

            return productionData;
        }

        private bool ProductionDataExists(int id)
        {
            return _context.ProductionData.Any(e => e.Id == id);
        }
    }
}
