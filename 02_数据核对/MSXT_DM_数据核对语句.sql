--��Ŀ�ؼ�Ҫ��
select t.c_projectcode         as ��Ŀ����,
       t.c_projname            as ��Ŀ����,
       t.c_projfullname        as ��Ŀȫ��,
       t1.c_deptname           as ��������,
       t.c_trustmanager        as ���о���,
       t.c_dealmanage          as ��Ӫ����,
       t.c_investmentmanager   as Ͷ�ʾ���,
       t.c_accountant          as ���л��,
       t.c_investment_officer  as Ͷ��רԱ,
       t.c_loan_officer        as ����רԱ,
       t.l_setupdate           as ��������,
       t.l_prestopdate         as Ԥ�Ƶ�������,
       t.l_stopdate            as ��������,
       t.l_extenddate          as ��������,
       t.c_projectphase        as ��Ŀ�׶�,
       t.c_projectphasename    as ��Ŀ�׶�˵��,
       t.c_projectstatus       as ��Ŀ�׶�,
       t.c_projectstatusname   as ��Ŀ�׶�˵��,
       t.c_intrustflag         as ҵ��Χ,
       t.c_intrustflagname     as ҵ��Χ˵��,
       t.c_projecttype         as ��Ŀ����,
       t.c_projecttypename     as ��Ŀ����˵��,
       t.c_projectpropertytype as �Ʋ�Ȩ����,
       t.c_projectpropertytype as �Ʋ�Ȩ����˵��,
       t.c_managetype          as ����ʽ,
       t.c_managetypename      as ����ʽ˵��,
       t.c_funtype             as ���ܷ���,
       t.c_funtypename         as ���ܷ���˵��,
       t.c_cootype             as ������ʽ,
       t.c_cootypename         as ������ʽ˵��,
       t.c_industry            as Ͷ����ҵ,
       t.c_industryname        as Ͷ����ҵ˵��,
       t.c_industrydtl1        as Ͷ����ҵ��ϸ,
       t.c_industrydtl1name    as Ͷ����ҵ��ϸ˵��,
       t.c_investarea          as Ͷ�ʷ�Χ,
       t.c_investareaname      as Ͷ�ʷ�Χ˵��,
       t.c_investdirection     as Ͷ�ʷ���,
       t.c_investdirectionname as Ͷ�ʷ���˵��,
       t.c_riskmeasure         as ������ʩ,
       t.c_riskmeasurename     as ������ʩ˵��
  from dim_projectinfo t, dim_department t1
 where t.l_deptid = t1.l_deptid
   and t.l_effective_flag = 1
 order by t.c_projectcode;

--�ڴιؼ�Ҫ�غ˶�
select a.c_stage_code  as �ڴα���,
       a.c_stage_name  as �ڴ�����,
       b.c_projectcode as ��Ŀ����,
       a.l_period      as �ڴ�,
       a.l_setup       as ��������,
       a.l_predate     as Ԥ�Ƶ�������,
       a.l_enddate     as ��������,
       a.f_trustpay    as ������
  from dim_stage a, dim_projectinfo b
 where a.l_projectid = b.l_projectid
   and b.l_effective_flag = 1
 order by a.c_stage_code;

--��Ŀ��ģ
select  b.c_projectcode,
       sum(a.f_balance_scale) / 100000000 as ��ǰ��ģ,
       sum(a.f_exist_scale_boy) / 100000000 as ���������ģ,
       sum(a.f_new_inc_scale) / 100000000 as ������ģ,
       sum(a.f_clear_scale) / 100000000 as �����ģ,
       sum(a.f_bridge_scale) / 100000000 as ���Ź�ģ,
       sum(a.f_net_inc_scale) / 100000000 as ������ģ
  from tt_project_daily a, dim_projectinfo b
 where a.l_projectid = b.l_projectid
   and b.l_effective_date <= a.l_dayid
   and b.l_expiration_date > a.l_dayid
   and a.l_dayid = 20161231
 group by b.c_projectcode
 order by b.c_projectcode;

--�ڴ����ȵĹ�ģ�˶�
select b.c_stage_code      as �ڴα���,
       a.f_exist_scale_boy as ���������ģ,
       a.f_new_inc_scale   as ����������ģ,
       a.f_clear_scale     as ������ٹ�ģ,
       a.f_net_inc_scale   as ������ģ,
       a.f_bridge_scale    as ���Ź�ģ,
       a.f_balanze_scale   as ��ģ���
  from tt_stage_daily a, dim_stage b, dim_projectinfo c
 where a.l_stageid = b.l_stageid
   and b.l_projectid = c.l_projectid
   and ((nvl(c.c_propertytype, '0') = '1' and b.l_period = 0) or
       (nvl(c.c_propertytype, '0') <> '1'))
   and a.l_dayid = 20161231
 order by b.c_stage_code;

--��Ŀ����
select sum(a.f_trust_pay + a.f_consultant_fee) / 10000 as ��������,
       sum(a.f_trust_pay) / 10000 as ���б���,
       sum(a.f_consultant_fee) / 10000 as �ƹ˷�,
       sum(a.f_new_income) / 10000 as ��������,
       sum(a.f_exist_income) / 10000 as ��������,
       sum(a.f_plan_new_income) / 10000 as �����ƻ�����,
       sum(a.f_plan_exist_income) / 10000 as �����ƻ�����
  from tt_project_monthly a, dim_projectinfo b
 where a.l_projectid = b.l_projectid
   and substr(b.l_effective_date, 1, 6) <= a.l_monthid
   and substr(b.l_expiration_date, 1, 6) > a.l_monthid
   and a.l_monthid = 201612;

--�ڴ����ȵ�����˶�
select b.c_stage_code           as �ڴα���,
       a.f_base_pay             as �������й̶�����,
       a.f_float_pay            as �������и�������,
       a.f_consultant_fee       as �������вƹ˷�,
       a.f_marketing_fee        as Ӫ������,
       a.f_share_trust_pay      as �������б���,
       a.f_share_consultant_fee as �������вƹ˷�,
       a.f_self_share           as ��Ӫ����
  from tt_stage_daily a, dim_stage b
 where a.l_stageid = b.l_stageid
   and a.l_dayid = 20161231
 order by b.c_stage_code;

--���ž�����ģ
select b.c_deptcode as ���ű���,
       b.c_deptname as ��������,
       sum(a.f_shared_scale) as �ֳɺ��ģ
  from tt_kpi_dept_stage_m a, dim_department b, dim_stage c
 where a.l_deptid = b.l_deptid
   and a.l_monthid = 201612
   and a.l_stageid = c.l_stageid
   and substr(c.l_setup, 1, 4) = 2016
 group by b.c_deptcode, b.c_deptname
 order by b.c_deptcode, b.c_deptname;

--ĳ�����·ֳɹ�ģ��ϸ
select c.c_stage_code as �ڴα���,
       c.c_stage_name as �ڴ�����,
       sum(a.f_shared_scale) as �ֳɺ��ģ
  from tt_kpi_dept_stage_m a, dim_department b, dim_stage c
 where a.l_deptid = b.l_deptid
   and a.l_monthid = 201612
   and a.l_stageid = c.l_stageid
   and substr(c.l_setup, 1, 4) = 2016
   and b.c_deptcode = '0_ms2003'
 group by c.c_stage_code, c.c_stage_name
 order by c.c_stage_code, c.c_stage_name;

--������������
select b.c_deptcode as ���ű���,
       b.c_deptname as ���ű���,
       sum(a.f_trust_pay) as ���б���,
       sum(a.f_consultant_fee) as �ƹ˷�,
       sum(a.f_sell_income) as �Ƹ�����,
       sum(a.f_income_sum) as ȷ������,
       sum(a.f_innate_income) as ��Ӫ����
  from tt_kpi_dept_stage_m a, dim_department b
 where a.l_deptid = b.l_deptid
   and a.l_monthid = 201612
 group by b.c_deptcode, b.c_deptname
 order by b.c_deptcode, b.c_deptname;

--�ֳɺ��ڴ�������ϸ
select b.c_stage_code,
       sum(a.f_trust_pay) as ���б���,
       sum(a.f_consultant_fee) as �ƹ˷�,
       sum(a.f_sell_income) as �Ƹ�����,
       sum(a.f_income_sum) as ȷ������,
       sum(a.f_innate_income) as ��Ӫ����
  from tt_kpi_dept_stage_m a, dim_stage b, dim_department c
 where a.l_deptid = c.l_deptid
   and a.l_stageid = b.l_stageid(+)
   and a.l_monthid = 201612
   --and c.c_deptcode = '0_ms1501'
 group by b.c_stage_code
 order by b.c_stage_code;
 
--�ڴ����ȿ��˺����б���
select b.c_stage_code, sum(a.f_trust_pay)
  from tt_kpi_dept_stage_m a, dim_stage b, dim_department c
 where a.l_stageid = b.l_stageid
   and a.l_deptid = c.l_deptid
   and a.l_monthid = 201612
 group by b.c_stage_code
having sum(a.f_trust_pay) <> 0
 order by b.c_stage_code;
 
--ȷ�����б���˶�
select b.c_stage_code as �ڴα���,
       sum(decode(c.quarter_desc, '1', a.f_trust_pay_sum, 0)) as һ�������б���,
       sum(decode(c.quarter_desc, '2', a.f_trust_pay_sum, 0)) as ���������б���,
       sum(decode(c.quarter_desc, '3', a.f_trust_pay_sum, 0)) as ���������б���,
       sum(decode(c.quarter_desc, '4', a.f_trust_pay_sum, 0)) as �ļ������б���
  from tt_kpi_income_quarter a, dim_stage b, dim_quarter c,dim_projectinfo d
 where a.l_stageid = b.l_stageid
   and a.l_quarterid = c.quarter_id
   and c.year_id = 2016
   and a.l_projectid = d.l_projectid
   and d.l_effective_date <= 20161231
   and d.l_expiration_date > 20161231
 group by b.c_stage_code
 order by b.c_stage_code;
select * from dim_projectinfo;
select * from dim_stage t where t.c_stage_code = 'F079-2';
select * from tt_kpi_income_quarter t where t.L_stageid = 19855;

--����ҵ��
select b.c_projectcode,
       sum(a.f_invest_capital - a.f_invest_back) / 100000000 as ��Ͷ���,
       sum(a.f_invest_return) / 10000 as Ͷ������,
       sum(a.f_innate_share) / 10000 as ��Ӫ����
  from tt_innate_income_daily a, dim_projectinfo b
 where a.l_projectid = b.l_projectid
   and a.l_dayid = 20161231
   and b.l_effective_date <= a.l_dayid
   and b.l_expiration_date > a.l_dayid
 group by b.c_projectcode
 order by b.c_projectcode;
 
--������չ����
select b.c_deptcode, sum(a.f_entry_cost_sum) / 10000
  from tt_cost_summary a, dim_department b
 where a.l_deptid = b.l_deptid
   and a.l_monthid = 201612
 group by b.c_deptcode
having sum(a.f_entry_cost_sum) / 10000 <> 0
order by b.c_deptcode;
