using System;
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
            // Calculate the total amount of produces Oil from each wellbore in the given interval

            throw new NotImplementedException();
        }

        [HttpGet("oil-avg-between-dates")]
        public object GetOilAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            // Calculate the average amount of Oil per wellbore in the given interval

            throw new NotImplementedException();
        }

        [HttpGet("gas-between-dates")]
        public object GetGasBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            // Calculate the total amount of produces Gas from each wellbore in the given interval

            throw new NotImplementedException();
        }

        [HttpGet("gas-avg-between-dates")]
        public object GetGasAvgBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            // Calculate the average amount of Gas per wellbore in the given interval

            throw new NotImplementedException();
        }

        [HttpGet("wellbore-records-between-dates")]
        public object GetWellboreRecordsBetweenDates(int? fromYear, int? toYear, int? fromMonth, int? toMonth)
        {
            // Calculate the number of wellbore records between 2 dates

            throw new NotImplementedException();
        }
    }
}