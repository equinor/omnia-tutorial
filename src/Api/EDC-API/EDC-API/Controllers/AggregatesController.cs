using System.Linq;
using EDC_API.Data;
using EDC_API.Models;
using Microsoft.AspNetCore.Mvc;

namespace EDC_API.Controllers
{
    [Route("api/aggregates")]
    [ApiController]
    public class AggregatesController : ControllerBase
    {
        private readonly CommonDbContext _context;

        public AggregatesController(CommonDbContext context)
        {
            _context = context;
        }
        [HttpGet("oil-between-dates")]
        public object GetOilBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = GetProductionDataBetweenDates(fromYear, toYear, fromMonth, toMonth);

            var uniqueWellbores = from pd in prodData
                                  group pd.Oil by pd.Wellbore into oilRecordsPerWellbore
                                  select new { Wellbore = oilRecordsPerWellbore.Key, OilSum = oilRecordsPerWellbore.Sum() };

            return uniqueWellbores.ToList();
        }

        [HttpGet("oil-avg-between-dates")]
        public object GetOilAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = GetProductionDataBetweenDates(fromYear, toYear, fromMonth, toMonth);

            var uniqueWellbores = from pd in prodData
                                  group pd.Oil by pd.Wellbore into oilRecordsPerWellbore
                                  select new { Wellbore = oilRecordsPerWellbore.Key, OilAvg = oilRecordsPerWellbore.Average() };

            return uniqueWellbores.ToList();
        }

        [HttpGet("gas-between-dates")]
        public object GetGasBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = GetProductionDataBetweenDates(fromYear, toYear, fromMonth, toMonth);

            var uniqueWellbores = from pd in prodData
                                  group pd.Gas by pd.Wellbore into gasRecordsPerWellbore
                                  select new
                                  {
                                      Wellbore = gasRecordsPerWellbore.Key,
                                      GasSum = gasRecordsPerWellbore.Sum()
                                  };

            return uniqueWellbores.ToList();
        }

        [HttpGet("gas-avg-between-dates")]
        public object GetGasAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = GetProductionDataBetweenDates(fromYear, toYear, fromMonth, toMonth);

            var uniqueWellbores = from pd in prodData
                                  group pd.Gas by pd.Wellbore into gasRecordsPerWellbore
                                  select new
                                  {
                                      Wellbore = gasRecordsPerWellbore.Key,
                                      GasAvg = gasRecordsPerWellbore.Average()
                                  };

            return uniqueWellbores.ToList();
        }

        [HttpGet("wellbore-records-between-dates")]
        public object GetWellboreRecordsBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            var prodData = GetProductionDataBetweenDates(fromYear, toYear, fromMonth, toMonth);

            var recordsPerWellbore = from pd in prodData
                                  group pd.Wellbore by pd.Wellbore into wellboreRecords
                                  select new
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