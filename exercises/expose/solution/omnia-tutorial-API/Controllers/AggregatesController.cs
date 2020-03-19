using Microsoft.AspNetCore.Mvc;
using omnia_tutorial.Data;
using omnia_tutorial.Models;
using System.Collections.Generic;
using System.Linq;

namespace omnia_tutorial.Controllers
{
    [Route("aggregates")]
    [ApiController]
    public class AggregatesController : ControllerBase
    {
        private readonly CommonDbContext _context;

        public AggregatesController(CommonDbContext context)
        {
            _context = context;
        }
        // GET: aggregates/oil-between-dates?fromYear={year}&toYear={year}&fromMonth={monthNumber}&toMonth={monthNumber}
        [HttpGet("oil-between-dates")]
        public ActionResult<List<OilBetweenDates>> GetOilBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = GetProductionDataBetweenDates(fromYear, toYear, fromMonth, toMonth);

            var uniqueWellbores = from pd in prodData
                                  group pd.Oil by pd.Wellbore into wellboreOilRecords
                                  select new OilBetweenDates
                                  {
                                      Wellbore = wellboreOilRecords.Key,
                                      OilSum = wellboreOilRecords.Sum()
                                  };

            return uniqueWellbores.ToList();
        }

        // GET: aggregates/oil-avg-between-dates?fromYear={year}&toYear={year}&fromMonth={monthNumber}&toMonth={monthNumber}
        [HttpGet("oil-avg-between-dates")]
        public ActionResult<List<OilAvgBetweenDates>> GetOilAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = GetProductionDataBetweenDates(fromYear, toYear, fromMonth, toMonth);

            var uniqueWellbores = from pd in prodData
                                  group pd.Oil by pd.Wellbore into wellboreOilRecords
                                  select new OilAvgBetweenDates
                                  {
                                      Wellbore = wellboreOilRecords.Key,
                                      OilAvg = wellboreOilRecords.Average()
                                  };

            return uniqueWellbores.ToList();
        }

        // GET: aggregates/gas-between-dates?fromYear={year}&toYear={year}&fromMonth={monthNumber}&toMonth={monthNumber}
        [HttpGet("gas-between-dates")]
        public ActionResult<List<GasBetweenDates>> GetGasBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = GetProductionDataBetweenDates(fromYear, toYear, fromMonth, toMonth);

            var uniqueWellbores = from pd in prodData
                                  group pd.Gas by pd.Wellbore into wellboreGasRecords
                                  select new GasBetweenDates
                                  {
                                      Wellbore = wellboreGasRecords.Key,
                                      GasSum = wellboreGasRecords.Sum()
                                  };

            return uniqueWellbores.ToList();
        }

        // GET: aggregates/gas-avg-between-dates?fromYear={year}&toYear={year}&fromMonth={monthNumber}&toMonth={monthNumber}
        [HttpGet("gas-avg-between-dates")]
        public ActionResult<List<GasAvgBetweenDates>> GetGasAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = GetProductionDataBetweenDates(fromYear, toYear, fromMonth, toMonth);

            var uniqueWellbores = from pd in prodData
                                  group pd.Gas by pd.Wellbore into wellboreGasRecords
                                  select new GasAvgBetweenDates
                                  {
                                      Wellbore = wellboreGasRecords.Key,
                                      GasAvg = wellboreGasRecords.Average()
                                  };

            return uniqueWellbores.ToList();
        }

        // GET: aggregates/wellbore-records-between-dates?fromYear={year}&toYear={year}&fromMonth={monthNumber}&toMonth={monthNumber}
        [HttpGet("wellbore-records-between-dates")]
        public ActionResult<List<WellboreRecordsBetweenDates>> GetWellboreRecordsBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = GetProductionDataBetweenDates(fromYear, toYear, fromMonth, toMonth);

            var recordsPerWellbore = from pd in prodData
                                     group pd.Wellbore by pd.Wellbore into wellboreRecords
                                     select new WellboreRecordsBetweenDates
                                     {
                                         Wellbore = wellboreRecords.Key,
                                         Records = wellboreRecords.Count()
                                     };

            return recordsPerWellbore.ToList();
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