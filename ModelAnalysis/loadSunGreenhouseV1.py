import pandas as pd
from datetime import datetime, timezone
import matplotlib.pyplot as plt
df = pd.read_csv ('../sunGreenhouseRun2July2021.csv')

#inital date is jan 1 2007
datetime_start = datetime(2007, 1, 1 , tzinfo=timezone.utc )
print( datetime_start)
secs_offset = datetime_start.timestamp()
print( secs_offset)

df['time']  = df['time'] + secs_offset


print(df)

print( datetime.fromtimestamp(secs_offset, timezone.utc))

format = '%Y-%m-%d %H:%M:%S'
df['Datetime'] = pd.to_datetime(df['time'] , unit='s' , utc=True)
df = df.set_index(['Datetime'])
print( df)



##Putting more readable labels
df['inside air temperature C']  = df['air.T'] - 273.15
df['outside air temperature C']  = df['weatherFromFile.weather.air_temp'] - 273.15
df['PAR watts/m2'] = (df["lightAbsorption.panels_PAR_transmitted[2]"] + df["lightAbsorption.panels_PAR_transmitted[1]"])/2.0

###set up for daily means, ex mean daily inside temperature
min30_mean_df = df.resample('30min').mean()
daily_mean_df = df.resample('D').mean()
monthly_mean_df = df.resample('M').mean()

###set up for daily integral or sum
daily_sum_df = min30_mean_df.resample('D').sum()
daily_sum_df['daily watt hours PAR / m2'] = daily_sum_df['PAR watts/m2']*0.5
daily_sum_df[ 'daily heating kwh / m2'] = daily_sum_df['climateController.heater_power']*0.001*0.5/2.0
daily_sum_df['daily mol PAR / m2'] = daily_sum_df['daily watt hours PAR / m2']*0.0164


#daily_sum_df.plot( y=['daily mol PAR / m2' ])
#df.plot( y=['inside air temperature C','outside air temperature C'  ])

###daily light integral
fig = plt.figure()
plt.xlabel('')
plt.ylabel('mol PAR $m^{-2}$ $day^{-1}$')
plt.title('Solar Greenhouse Light')

x = daily_sum_df.index.tolist()
y = daily_sum_df['daily mol PAR / m2'].tolist()
plt.plot(x, y, label='')

plt.legend()
plt.grid()
plt.show()

##temperature
fig = plt.figure()
plt.xlabel('')
plt.ylabel('Temperature, C')
plt.title('Solar Greenhouse Temperature')

x = min30_mean_df.index.tolist()
y = min30_mean_df['inside air temperature C'].tolist()
plt.plot(x, y, label='Greenhouse air temperature')

x = min30_mean_df.index.tolist()
y = min30_mean_df['outside air temperature C'].tolist()
plt.plot(x, y, label='Outside air temperature')

x = daily_mean_df.index.tolist()
y = daily_mean_df['inside air temperature C'].tolist()
plt.plot(x, y, label='Daily mean greenhouse air temperature')

plt.legend()
plt.grid()
plt.show()

##heating demand
fig = plt.figure()
plt.xlabel('')
plt.ylabel('heating daily kwh per m2 of floor area')
plt.title('Solar Greenhouse Suplemental Heating')

x = daily_sum_df.index.tolist()
y = daily_sum_df[ 'daily heating kwh / m2'].tolist()
plt.plot(x, y, label='')

plt.legend()
plt.grid()
plt.show()
