import pandas as pd
from datetime import datetime, timezone
import matplotlib.pyplot as plt
dc = pd.read_csv ('../sunGreenhouseRun2July2021.csv')

#inital date is jan 1 2007
datetime_start = datetime(2007, 1, 1 , tzinfo=timezone.utc )
print( datetime_start)
secs_offset = datetime_start.timestamp()
print( secs_offset)

dc['time']  = dc['time'] + secs_offset


print(dc)

print( datetime.fromtimestamp(secs_offset, timezone.utc))

format = '%Y-%m-%d %H:%M:%S'
dc['Datetime'] = pd.to_datetime(dc['time'] , unit='s' , utc=True)
dc = dc.set_index(['Datetime'])
print( dc)



##Putting more readable labels
dc['inside air temperature C']  = dc['air.T'] - 273.15
dc['outside air temperature C']  = dc['weatherFromFile.weather.air_temp'] - 273.15
dc['PAR watts/m2'] =  dc["lightAbsorption.panels_PAR_transmitted[1]"])

###set up for daily means, ex mean daily inside temperature
min30_mean_dc = dc.resample('30min').mean()
daily_mean_dc = dc.resample('D').mean()
monthly_mean_dc = dc.resample('M').mean()

###set up for daily integral or sum
daily_sum_dc = min30_mean_dc.resample('D').sum()
daily_sum_dc['daily watt hours PAR / m2'] = daily_sum_dc['PAR watts/m2']*0.5
daily_sum_dc[ 'daily heating kwh / m2'] = daily_sum_dc['climateController.heater_power']*0.001*0.5/2.0
daily_sum_dc['daily mol PAR / m2'] = daily_sum_dc['daily watt hours PAR / m2']*0.0164
