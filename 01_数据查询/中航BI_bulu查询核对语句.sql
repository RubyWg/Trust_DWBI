select *
  from hstdc.ta_fundinfo a
 where exists
 (select 1 from hstdc.ta_order b where a.c_fundcode = b.c_fundcode);

--�и��Ѽƻ����޷�������TAʵ�ʲ�Ʒ��
select b.*, a.*
  from bulu_amfareplan a
 left outer join (select b3.c_projcode,
                          b3.c_fullname,
                          b3.d_begdate,
                          b3.c_projphase,
                          b1.c_fundcode,
                          b1.d_setupdate,
                          b1.d_issuedate
                     from hstdc.ta_fundinfo b1, hstdc.pm_projectinfo b3
                    where b1.c_projcode = b3.c_projcode
                      and exists
                    (select 1
                             from hstdc.ta_order b2
                            where b1.c_fundcode = b2.c_fundcode)) b
    on a.vc_product_id = b.c_fundcode
 where b.c_fundcode is null order by a.l_begin_date;

--TCMP��Ŀֻ��1��TA��Ʒ����û�и��Ѽƻ���
with temp_fundinfo as
 (select c.*,d.*
    from hstdc.ta_fundinfo c,
         (select a.c_projcode as c_proj_code,a.d_begdate,a.d_enddate as d_expiry,e.c_orgname,count(*) as ct
            from hstdc.pm_projectinfo a, hstdc.ta_fundinfo b,hstdc.hr_org e
           where a.c_projcode = b.c_projcode and nvl(a.d_enddate,to_date('20991231','YYYYMMDD')) >= to_date('20150101','YYYYMMDD')
           and a.c_dptid = e.c_orgid
           group by a.c_projcode,a.d_begdate,a.d_enddate,e.c_orgname) d
   where c.c_projcode = d.c_proj_code
     and d.ct = 1)
select t2.c_fundcode as ��Ʒ����,t2.c_fundname as ��Ʒ����,t2.c_proj_code as ��Ŀ����,t2.d_begdate as ��Ŀ��������,t2.d_expiry as ��Ŀ��ֹ����,t2.c_orgname as ����
  from bulu_amfareplan t1
 right outer join temp_fundinfo t2
    on t2.c_fundcode = t1.vc_product_id
   and t1.vc_product_id is null
   order by t2.c_orgname,t2.d_begdate;

--����Ӳ�Ʒ�ĵ�δ���Ӳ�Ʒ����
with temp_fundinfo as
(select c.*
  from hstdc.ta_fundinfo c,
       (select a.c_projcode, count(*) as ct
          from hstdc.pm_projectinfo a, hstdc.ta_fundinfo b
         where a.c_projcode = b.c_projcode
         group by a.c_projcode) d
 where c.c_projcode = d.c_projcode
   and d.ct > 1)
select b.c_projcode as ��Ŀ����,
     b.c_fullname as ��Ŀ����,
     b.c_dptid as ���ű���,
     b.c_orgname as ��������,
     b.d_begdate as ��Ŀ��������,
     b.c_fundcode as TA��Ʒ����,
     a.l_serial_no as �������к�,
     a.vc_product_id as AM��ƷID,
     a.c_ext_flag as �������,
     a.l_begin_date as ��Ϣ��,
     a.l_end_date as ��Ϣ��,
     a.en_rate as ����,
     a.en_plan_balance as �ƻ����,
     a.vc_code as �Ӳ�Ʒ����,
     a.vc_remark as ��ע 
from (select t1.*
        from bulu_amfareplan t1, temp_fundinfo t2
       where t1.vc_product_id = t2.c_fundcode) a
left outer join (select t2.c_projcode,
                        t2.c_fullname,
                        t2.c_dptid,
                        t3.c_orgname,
                        t2.d_begdate,
                        t1.c_fundcode
                   from hstdc.ta_fundinfo t1, hstdc.pm_projectinfo t2,hstdc.hr_org t3
                  where t1.c_projcode = t2.c_projcode and t2.c_dptid = t3.c_orgid) b
  on a.vc_product_id = b.c_fundcode
where a.vc_code is null order by b.c_dptid,b.d_begdate,b.c_projcode;

--���ڹ�ģ�Ĳ�Ʒ��û�и��Ѽƻ�
select b.*, a.*
  from bulu_amfareplan a
 right outer join (select b3.c_projcode,
                          b3.c_fullname,
                          b3.d_begdate,
                          b3.c_projphase,
                          b1.c_fundcode,
                          b1.d_setupdate,
                          b1.d_issuedate
                     from hstdc.ta_fundinfo b1, hstdc.pm_projectinfo b3
                    where b1.c_projcode = b3.c_projcode
                      and exists
                    (select 1
                             from hstdc.ta_order b2
                            where b1.c_fundcode = b2.c_fundcode)) b
    on a.vc_product_id = b.c_fundcode
 where a.vc_product_id is null order by b.d_begdate;

select t.*
  from bulu_amfareplan t, hstdc.ta_fundinfo s
 where t.vc_product_id = s.c_fundcode
   and s.c_projcode = 'AVICTC2015X1091';

select * from hstdc.ta_fundinfo t where t.c_projcode = 'AVICTC2015X1091';

select * from hstdc.pm_projectinfo t where t.c_fullname like '%����707%';

--��Ŀ�����ⲿ����
select t.C_PROJECTCODE,t.C_PROJECTCODEALIAS from tprojectinfo_tcmp t where t.C_PROJECTCODE <> t.C_PROJECTCODEALIAS;

--��Ŀ���
select *
  from nc_vouchers t
 where t.c_subcode like '1001%'
   and t.d_busi <= to_date('20160630', 'yyyymmdd') --and t.d_busi >= to_date('20160601', 'yyyymmdd')
   and t.c_fundid = '0001A1100000000002IE' order by t.l_year desc,t.l_month desc;
   
select sum(t.f_debit), sum(t.f_credit), sum(t.f_debit - t.f_credit)
  from nc_vouchers t
 where t.c_subcode like '1001%'
   and t.d_busi <= to_date('20160630', 'yyyymmdd') and t.d_busi >= to_date('20160101', 'yyyymmdd')
   and t.c_fundid = '0001A1100000000002IE';
   
SELECT AM_ORDER.C_ORDERID,
       AM_ORDER.C_PROJCODE,
       AM_ORDER.C_FUNDCODE,
       AM_ORDER.C_EXTYPE,
       AM_ORDER.D_DATE,
       AM_ORDER.D_DELIVERY,
       AM_ORDER.C_REMARK,
       AM_ORDER.F_DLVAMOUNT,
       am_order.c_status
  FROM AM_ORDER
 WHERE AM_ORDER.L_BUSIID = 22151
   and AM_ORDER.C_EXTYPE in ('101', '102', '105', '106')
   and AM_ORDER.C_PROJCODE is  null
   and AM_ORDER.D_DELIVERY <= to_date('20160930', 'yyyymmdd')
   and AM_ORDER.D_DELIVERY is not null
   --and am_order.c_projcode = 'AVICTC2014X0641' /*am_order.c_fundcode in ('ZH03Y8','ZH044Q')*/
 order by AM_ORDER.D_DELIVERY;
 

SELECT NC_FUNDINFO.C_FUNDID_HS,
       NC_VOUCHERS.C_JOURID,
       NC_VOUCHERS.D_BUSI,
       NC_VOUCHERS.C_DIGEST,
       NC_VOUCHERS.C_SUBCODE,
       NC_VOUCHERS.C_SUBNAME,
       NC_VOUCHERS.L_BALDIR,
       NC_VOUCHERS.F_DEBIT,
       NC_VOUCHERS.F_CREDIT,
       NC_VOUCHERS.L_STATE,
       NC_VOUCHERS.L_YEAR,
       NC_VOUCHERS.L_MONTH,
       NC_ASITEM.C_ITEMNO,
       NC_ASCLASS.C_CLASSNO
  FROM NC_FUNDINFO, NC_VOUCHERS, NC_ASITEM, NC_ASCLASS
 WHERE NC_ASCLASS.C_CLASSNO in ('2', 'jobass') --���ź���Ŀ�������� 
   AND NC_VOUCHERS.C_FUNDID = NC_FUNDINFO.C_FUNDID
   and NC_VOUCHERS.C_COMBID = NC_ASITEM.C_COMBID
   and NC_ASITEM.C_CLASSID = NC_ASCLASS.C_CLASSID;
  
  select * from nc_vouchers a,nc_fundinfo b where a.c_fundid = b.c_fundid;
select * from nc_fundinfo;
