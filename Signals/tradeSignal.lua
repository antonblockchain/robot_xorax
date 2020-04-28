-- scriptTest.lua (in your scripts directory)
local M = {}

local loger = dofile(getScriptPath() .. "\\loger.lua");
local label = dofile(getScriptPath() .. "\\drawLabel.lua");

M.status = 0;

local collbackFunc;

-- три состояния, 

-- как должна ходить цена для сигнала
-- здесь мы не учитываем ничего
local rangeLocal = 0.0

-- U-turn
local rangeUturn = 0.2 

local signalStrength = 0;
-- старая цена
local oldPrice = 0;


-- старый объём
local oldVolume = 0;
-- старый объём в прошлый тик
local  lastTickVolume = 0;




 -- новая цена
local newPrice = 0; 

-- объём в тик новый объём
local volumeRange = 0;
-- старый объём для сравнения в тик
local oldVolumeRange = 0;

-- объём в тик новый объём
local countingTicsVolume = 0;

-- свечки
--local number_of_candles = 0;
--local old_number_of_candles  = 0;
-- критический уровень объёма
local CRITICAL_VOLUME= 0;



local function  calculateVolume( volume)
     
-- объём для решения
local rangeVolume = 10


    -- новая свеча
    if (setting.old_number_of_candles  ~= setting.number_of_candles ) then 
        setting.old_number_of_candles = setting.number_of_candles;
        -- если новая свечка
        volumeRange =  volume;
        return
    end

    if oldVolume == volume then
        return
    end

    if oldVolume == 0 then 
        oldVolume =  volume
        return
    end
    -- вычисляем текущий объём
    -- это разница объёмов
    local updateValue = volume - oldVolume;
 

    if   lastTickVolume + rangeVolume <= updateValue  then 
    
        -- увеличение объёмов
        
      --  loger.save(countingTicsVolume .." +  объёмов "..  lastTickVolume .. ' '.. updateValue..' rand ' );
        countingTicsVolume =  countingTicsVolume + 1;
    end


    if lastTickVolume - rangeVolume >= updateValue  then 
        volumeRange = oldVolume - volume;
                -- уменьшение объёмов 
                if countingTicsVolume > 1  then 
                     countingTicsVolume =   countingTicsVolume - 2;
                 end         

            --    loger.save(countingTicsVolume .."  -  объёмов "..  lastTickVolume .. ' '.. updateValue..' rand ' );
     --   end

    end

    oldVolume = volume;  
    lastTickVolume = updateValue;
     
end

local function  calculatePrice( price,datetime)
    -- 
    -- для тестирования  collbackFunc( price, 1, datetime, 'BUY' );

    -- цена выросла
    if oldPrice == 0 then
        oldPrice = price;
        return
    end
    --  loger.save(rangeLocal .. "  цена выросла " ..price.. '   oldPrice '..  oldPrice)
  --  loger.save(rangeLocal .. "  цена выросла " ..price.. '   oldPrice '..  oldPrice)
  
--0.03  цена выросла 31.1   oldPrice 31.1
    if oldPrice + rangeLocal < price   then

     --   loger.save(rangeLocal .. "  цена выросла == " ..price.. '   oldPrice '..  oldPrice)

        if(countingTicsVolume > CRITICAL_VOLUME)  then
            --  цена и объём  растёт  стремительно 
      --  loger.save( " покупка или продажа цена и объём + " .. volumeRange ..' | '.. countingTicsVolume ..' | '.. CRITICAL_VOLUME..' | '..price..' | '..oldPrice )
      
        collbackFunc( price, countingTicsVolume, datetime, 'SELL' );
        end
    end
     

    -- цена упала
    if oldPrice - rangeLocal > price then
     --   loger.save((oldPrice + rangeLocal) .. "   цена упала "..price)
     --   oldPrice = price;

      --  loger.save(countingTicsVolume.. "  countingTicsVolume " .. CRITICAL_VOLUME)
        if(countingTicsVolume > CRITICAL_VOLUME) then
         --   loger.save( " покупка или продажа цена и объём - " .. volumeRange ..' | '.. countingTicsVolume ..' | '.. CRITICAL_VOLUME..' | '..price..' | '..oldPrice )
            --  цена  и объём падает стремительно 

            collbackFunc( price, countingTicsVolume, datetime, 'BUY');
        end
    end
    oldPrice = price;
end

-- вычисляем сигнал
local function  calculateSignal(object)
   
    calculateVolume(object.volume)
    calculatePrice(object.close, object.datetime) 

end;




local function  setRange(range)

rangeLocal = rangegetNumCandle
 

end;

local function  getRange()
    return rangeLocal;
end;



    --    local O = t[i].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
    --    local H = t[i].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
    --    local L = t[i].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
    --    local C = t[i].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
    --    local V = t[i].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
    --    local T = t[i].datetime; -- Получить значение datetime для указанной свечи

    -- обрабатываем сигналы каждый тик
    -- Обязательное условие это подключение к графику по тегу


local function getSignal(tag, callback)
    seconds = os.time(datetime); -- в seconds будет значение 1427052491

    collbackFunc = callback;
    shift = 0;

    setting.number_of_candles = getNumCandles(setting.tag); 
    bars_temp,res,legend = getCandlesByIndex(setting.tag, 0, setting.number_of_candles-2*len-shift,2*len)

    local lines_count = getLinesCount(tag) 
    bars={}

    i=len
    j=2*len
 
    while i>=1 do

     if(bars_temp[j-1].datetime.hour == nul)then

     end
            if bars_temp[j-1].datetime.hour >= 10 then
                    sk=true
                    if bars_temp[j-1].datetime.hour ==18 and bars_temp[j-1].datetime.min==45 then
                            sk=false
                    end
                    if sk then
                            bars[i]=bars_temp[j-1] 
                          calculateSignal( bars[len] )
                          i=i-1
                    end
            end
            j=j-1

    end

    t = len+1
    return value
	  
end
M.getSignal = getSignal
M.setRange = setRange
M.getRange = getRange

return M