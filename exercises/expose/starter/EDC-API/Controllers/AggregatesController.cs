using System;
using System.Collections.Generic;
using System.Linq;
using EDC_API.Data;
using EDC_API.Models;
using Microsoft.AspNetCore.Mvc;

namespace EDC_API.Controllers
{
    [Route("aggregates")]
    [ApiController]
    public class AggregatesController : ControllerBase
    {
        private readonly CommonDbContext _context;

        /*
         * HINT: 
         * 1) Look at the return types of each endpoint. 
         * This will show what the endpoint should return. e.g. in the GetOilBetweenDates method, look at the OilBetweenDates class.
         * 2) Use the GetProductionDataBetweenDates helper method at the bottom.
         * 3) Use LINQ to create SQL queries. 
         */
        public AggregatesController(CommonDbContext context)
        {
            _context = context;
        }

        // GET: aggregates/oil-between-dates?fromYear={year}&toYear={year}&fromMonth={monthNumber}&toMonth={monthNumber}
        [HttpGet("oil-between-dates")]
        public ActionResult<List<OilBetweenDates>> GetOilBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {

            // An array with the total amount of Oil from each wellbore in the given interval. See the OilBetweenDates class
            throw new NotImplementedException();
        }

        // GET: aggregates/oil-avg-between-dates?fromYear={year}&toYear={year}&fromMonth={monthNumber}&toMonth={monthNumber}
        [HttpGet("oil-avg-between-dates")]
        public ActionResult<List<OilAvgBetweenDates>> GetOilAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            // An array with the average amount of Oil per wellbore in the given interval. See the OilAvgBetweenDates class

            throw new NotImplementedException();
        }

        // GET: aggregates/gas-between-dates?fromYear={year}&toYear={year}&fromMonth={monthNumber}&toMonth={monthNumber}
        [HttpGet("gas-between-dates")]
        public ActionResult<List<GasBetweenDates>> GetGasBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            // An array with the total amount of produces Gas from each wellbore in the given interval. See the GasBetweenDates class

            throw new NotImplementedException();
        }

        // GET: aggregates/gas-avg-between-dates?fromYear={year}&toYear={year}&fromMonth={monthNumber}&toMonth={monthNumber}
        [HttpGet("gas-avg-between-dates")]
        public ActionResult<List<GasAvgBetweenDates>> GetGasAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            // An array with the average amount of Gas per wellbore in the given interval. See the GasAvgBetweenDates class

            throw new NotImplementedException();
        }

        // GET: aggregates/wellbore-records-between-dates?fromYear={year}&toYear={year}&fromMonth={monthNumber}&toMonth={monthNumber}
        [HttpGet("wellbore-records-between-dates")]
        public ActionResult<List<WellBoreRecordsBetweenDates>> GetWellboreRecordsBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            // An array with the number of wellbore records per wellbore in the given interval. See the WellboreRecordsBetweenDates class

            throw new NotImplementedException();
        }

        private IQueryable<ProductionData> GetProductionDataBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = _context.ProductionData.AsQueryable();

            if (fromYear != null)
            {
                prodData = prodData.Where(pa => pa.Year >= fromYear);
            }
            if (toYear != null)
            {
                prodData = prodData.Where(pa => pa.Year <= toYear);
            }
            if (fromMonth != null)
            {
                prodData = prodData.Where(pa => pa.Month >= fromMonth);
            }
            if (toMonth != null)
            {
                prodData = prodData.Where(pa => pa.Month <= toMonth);
            }

            return prodData;
        }
    }
}