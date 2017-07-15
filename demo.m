function myui
    f = figure;
    myData = { 'A '  31; 'B'  41; 'C'  5; 'D' 2.6};
    t = uitable('Parrent',f,...
                'Position', [25 25 700 200], ...
                'Data',myData,...
                'ColumnEditable', [true true], ...
                'CellEditCallback',@converttonum);
        function converttonum(hObject,callbackdata)
             numval = eval(callbackdata.EditData);
             r = callbackdata.Indices(1)
             c = callbackdata.Indices(2)
             hObject.Data{r,c} = numval; 
        end
end