function rebootCamera(camNum)
    if camNum<10
        additionalZero = '0';
    else 
        additionalZero = '';
    end
    webwrite(['http://10.19.2.1' additionalZero num2str(camNum) '/control/reboot'],'power',true);
end

