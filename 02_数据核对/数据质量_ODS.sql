--��Ҫ����SQL
SELECT TSHARECURRENTS.D_CDATE,
       TSHARECURRENTS.C_BUSINFLAG,
       TSHARECURRENTS.C_FUNDCODE,
       SUM(TSHARECURRENTS.F_OCCURESHARES)
  FROM TSHARECURRENTS where TSHARECURRENTS.c_Fundcode = 'CA01C3'
 GROUP BY TSHARECURRENTS.D_CDATE,
          TSHARECURRENTS.C_BUSINFLAG,
          TSHARECURRENTS.C_FUNDCODE;
--�ֺ��¼         
SELECT TDIVIDENDDETAIL.D_CDATE,
       TDIVIDENDDETAIL.C_CSERIALNO,
       TDIVIDENDDETAIL.D_DATE,
       TDIVIDENDDETAIL.C_FUNDCODE,
       TDIVIDENDDETAIL.F_TOTALSHARE,
       TDIVIDENDDETAIL.f_Realbalance,
       TDIVIDENDDETAIL.c_Flag,
       TDIVIDENDDETAIL.*
  FROM TDIVIDENDDETAIL where TDIVIDENDDETAIL.c_Fundcode = 'CA01C3';
--�Ƿ񷵱�
select t.d_registerdate,t.c_isprincipalrepayment,t.* from tprofitschema t where t.c_fundcode = 'CA01C3';
--���׼�¼
select t.c_businflag,
                t.c_outbusinflag,
                t.d_cdate,
                t.c_fundacco,
                t.f_confirmbalance,
                t.f_confirmshares,
                t.f_netvalue
           from tconfirm t
          where t.c_fundcode = 'CA01C3'
            and t.c_businflag not in ('01')
          order by t.d_cdate;

--������޷ֺ��Ʒ
select distinct t.c_fundcode
  from tconfirm t
 where not exists (select 1
          from tconfirm a
         where t.c_cserialno = a.c_cserialno
           and a.c_businflag = '03')
   and not exists
 (select 1
          from tdividenddetail b
         where t.l_certificateserialno = b.l_certificateserialno
           and t.c_fundacco = b.c_fundacco);

--�޾�ֵ��Ʒ
select * from tfundinfo t where t.c_fundcode
   
