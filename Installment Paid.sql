create or replace procedure contract(v_contract_id number,v_CONTRACT_STARTDATE date,v_CONTRACT_ENDDATE date,v_CONTRACT_TOTAL_FEES number ,v_CONTRACT_DEPOSIT_FEES number,v_CONTRACT_PAYMENT_TYPE varchar2) is

  v_years number (4);
  v_total_fee number (14,4);
  installment_date date:=v_CONTRACT_STARTDATE;

begin
v_years := trunc(months_between(v_CONTRACT_ENDDATE, v_CONTRACT_STARTDATE)/12);

   if v_CONTRACT_PAYMENT_TYPE = 'ANNUAL' then 
       if v_CONTRACT_DEPOSIT_FEES is null then
        v_total_fee := v_CONTRACT_TOTAL_FEES / v_years;  
        
    else
        v_total_fee := (v_CONTRACT_TOTAL_FEES - v_CONTRACT_DEPOSIT_FEES) / v_years;
      end if;
      
    for i in 1..v_years loop
    
       insert into INSTALLMENTS_PAID (CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT, PAID)
        values (v_contract_id, installment_date,v_total_fee,0);
         installment_date:=add_months(v_CONTRACT_STARTDATE,12*i);
         
        end loop;    
      end if;       
      
     
      
    if v_CONTRACT_PAYMENT_TYPE = 'HALF_ANNUAL' then 
       if v_CONTRACT_DEPOSIT_FEES is null then
        v_total_fee := v_CONTRACT_TOTAL_FEES / (v_years*2);  
        
    else
        v_total_fee := (v_CONTRACT_TOTAL_FEES - v_CONTRACT_DEPOSIT_FEES) / (v_years*2);
      end if;
      
    for i in 1..v_years*2 loop
     
       insert into INSTALLMENTS_PAID (CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT, PAID)
        values (v_contract_id, installment_date,v_total_fee,0);
        installment_date:=add_months(v_CONTRACT_STARTDATE,6*i);
        end loop;    
    end if;  
      
      
            
    if v_CONTRACT_PAYMENT_TYPE = 'MONTHLY' then 
       if v_CONTRACT_DEPOSIT_FEES is null then
        v_total_fee := v_CONTRACT_TOTAL_FEES / (v_years*12);  
        
     else
        v_total_fee := (v_CONTRACT_TOTAL_FEES - v_CONTRACT_DEPOSIT_FEES) / (v_years*12);
      end if;
     
      for i in 1..v_years*12 loop
       insert into INSTALLMENTS_PAID (CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT, PAID)
        values (v_contract_id, installment_date,v_total_fee,0);
        installment_date:=add_months(v_CONTRACT_STARTDATE,i);
      end loop;    
    end if;  
      
     
            
    if v_CONTRACT_PAYMENT_TYPE = 'QUARTER' then 
       if v_CONTRACT_DEPOSIT_FEES is null then
        v_total_fee := v_CONTRACT_TOTAL_FEES / (v_years*4);  
        
      else
        v_total_fee := (v_CONTRACT_TOTAL_FEES - v_CONTRACT_DEPOSIT_FEES) / (v_years*4);
        end if;
        
      for i in 1..v_years*4 loop
       insert into INSTALLMENTS_PAID (CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT, PAID)
        values (v_contract_id, installment_date,v_total_fee,0);
           installment_date:=add_months(v_CONTRACT_STARTDATE,i*3);
      end loop;    
    end if;  

end;

declare
 cursor c is select * from contracts;

begin
for f in c loop
contract(F.CONTRACT_ID,f.CONTRACT_STARTDATE,f.CONTRACT_ENDDATE,f.CONTRACT_TOTAL_FEES,f.CONTRACT_DEPOSIT_FEES,f.CONTRACT_PAYMENT_TYPE);
end loop;
end;

show error
      
      
      
      
