--��Ŀ�ؼ�Ҫ��
select a.c_proj_code,
       a.c_proj_name,
       a.c_name_full,
       c.c_dept_name,
       (select c_emp_name
          from dim_pb_employee
         where l_emp_id = a.l_tstmgr_id) as ���о���,
       (select c_emp_name from dim_pb_employee where l_emp_id = a.l_opmgr_id) as ��Ӫ����,
       (select c_emp_name
          from dim_pb_employee
         where l_emp_id = a.l_invmgr_id) as Ͷ�ʾ���,
       (select c_emp_name
          from dim_pb_employee
         where l_emp_id = a.l_tstacct_id) as ���л��,
       (select c_emp_name
          from dim_pb_employee
         where l_emp_id = a.l_invclerk_id) as Ͷ��רԱ,
       (select c_emp_name
          from dim_pb_employee
         where l_emp_id = a.l_loanclerk_id) as ����רԱ,
       a.l_setup_date as ��������,
       a.l_preexp_date as Ԥ�Ƶ�������,
       a.l_expiry_date as ��������,
       a.l_extend_date as ��������,
       a.c_proj_phase as ��Ŀ�׶�,
       a.c_proj_phase_n as ��Ŀ�׶�˵��,
       a.c_proj_status as ��Ŀ״̬,
       a.c_proj_status_n as ��Ŀ״̬˵��,
       b.c_busi_scope as ҵ��Χ,
       b.c_busi_scope_n as ҵ��Χ˵��,
       b.c_proj_type as ��Ŀ����,
       b.c_proj_type_n as ��Ŀ����˵��,
       b.c_property_type as �Ʋ�Ȩ����,
       b.c_property_type_n as �Ʋ�Ȩ����˵��,
       b.c_manage_type as ����ʽ,
       b.c_manage_type_n as ����ʽ˵��,
       b.c_func_type as ���ܷ���,
       b.c_func_type_n as ���ܷ���˵��,
       b.c_coop_type as ������ʽ,
       b.c_coop_type_n as ������ʽ˵��,
       b.c_invest_indus as Ͷ����ҵ,
       b.c_invest_indus_n as Ͷ����ҵ˵��,
       b.c_invest_way as Ͷ�ʷ�ʽ,
       b.c_invest_way_n as Ͷ�ʷ�ʽ˵��,
       b.c_invest_dir as Ͷ�ʷ���,
       b.c_invest_dir_n as Ͷ�ʷ���˵��,
       null as ������ʩ,
       null as ������ʩ˵��
  from dim_pb_project_basic a, dim_pb_project_biz b, dim_pb_department c
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and a.l_effective_flag = 1
 order by a.c_proj_code;

--�ڴιؼ�Ҫ�غ˶�
select a.c_stage_code  as �ڴα���,
       a.c_stage_name  as �ڴ�����,
       b.c_proj_code   as ��Ŀ����,
       a.l_period      as �ڴ�,
       a.l_setup_date  as ��������,
       a.l_preexp_date as Ԥ�Ƶ�������,
       a.l_expiry_date     as ��������,
       a.f_trustpay    as ������
  from dim_sr_stage a, dim_pb_project_basic b
 where a.l_stage_id = b.l_proj_id
   and b.l_effective_flag = 1
 order by a.c_stage_code;

--���й�ģ
select sum(a.f_balance_agg) / 100000000 as ʱ���ģ,
       sum(decode(c.c_busi_scope,'1',a.f_balance_agg)) / 100000000 as ����ʱ���ģ,
       sum(case when c.c_busi_scope = '1' and c.c_manage_type= '1' then a.f_balance_agg else 0 end)/100000000 as ����������ʱ���ģ,
       sum(decode(c.c_busi_scope,'2',a.f_balance_agg)) / 100000000 as ����ʱ���ģ,
       sum(case when c.c_busi_scope = '2' and c.c_manage_type= '1' then a.f_balance_agg else 0 end)/100000000 as ���������ʱ���ģ
  from tt_sr_scale_stage_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;
   
--��˾����
select sum(case when c.c_ietype_code_l1 in ('XTSR','TZSR') then a.f_planned_eoy end )/10000 as ��ͬ����,
       sum(case when c.c_ietype_code_l1 in ('XTSR') then a.f_planned_eoy end )/10000 as ��ͬ���л�������,
       sum(case when c.c_ietype_code_l1 in ('TZSR') then a.f_planned_eoy end )/10000 as ��ͬ��Ӫ����
  from tt_sr_ie_stage_m a,
       dim_pb_ie_type   c,
       dim_pb_ie_status d,
       dim_pb_project_basic e,
       dim_pb_project_biz f
 where a.l_month_id = 201612
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 0--��ȷ������
   and a.l_proj_id = e.l_proj_id
   and e.l_proj_id = f.l_proj_id
   and substr(e.l_effective_date, 1, 6) <= a.l_month_id
   and substr(e.l_expiration_date, 1, 6) > a.l_month_id;

--���ŷ���
select c.c_dept_code,
       sum(case when b.c_subj_code_l2 = '660102' or b.c_subj_code_l3 = '66010301' then a.f_amount_eot else 0 end)/10000 as �����ճ�����չ����
  from tt_fi_accounting_dept_m a, dim_fi_subject b,dim_pb_department c
 where a.l_month_id = 201612
   and a.l_subj_id = b.l_subj_id
   and a.l_dept_id = c.l_dept_id 
   and substr(c.l_effective_date, 1, 6) <= a.l_month_id
   and substr(c.l_expiration_date, 1, 6) > a.l_month_id
   group by c.c_dept_code
   order by c.c_dept_code;

--��ǰ���й�ģ
select sum(a.f_balance_agg) / 100000000 as ��ǰ����,
       sum(a.f_increase_eot) / 100000000 as ��������,
       sum(a.f_decrease_eot) / 100000000 as ��������
  from tt_sr_scale_stage_m a, dim_sr_stage b
 where a.l_stage_id = b.l_stage_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;

--������й�ģ
select sum(a.f_balacne_bot) / 100000000 as ���������ģ
  from tt_sr_scale_stage_m a, dim_sr_stage b
 where a.l_stage_id = b.l_stage_id
   and a.l_month_id = 201601
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;

--��ǰ��������
select sum(decode(c.c_ietype_code_l1, 'XTSR', a.f_planned_eoy, 0))/10000 as ��������,
       sum(case when c.c_ietype_code_l2 = 'XTBC' then a.f_planned_eoy else 0 end)/10000 as ������������,
       sum(case when c.c_ietype_code_l2 = 'XTCGF' then a.f_planned_eoy else 0 end)/10000 as ������������
  from tt_sr_ie_stage_m a,
       dim_sr_stage     b,
       dim_pb_ie_type   c,
       dim_pb_ie_status d
 where a.l_stage_id = b.l_stage_id
   and a.l_month_id = 201612
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 1
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;

--�ڴ����ȵĹ�ģ�˶�
with temp_bridge as
 (select t1.l_month_id, t1.l_stage_id, sum(t1.f_scale_eot) as f_scale_eot
    from tt_sr_scale_type_m t1, dim_pb_scale_type t2
   where t1.l_scatype_id = t2.l_scatype_id
     and t2.c_scatype_code = '62'
   group by t1.l_month_id, t1.l_stage_id)
select b.c_stage_code as �ڴα���,
       a.f_increase_eot as ����������ģ,
       a.f_decrease_eot as ������ٹ�ģ,
       decode(substr(b.l_setup_date, 1, 4),
              substr(a.l_month_id, 1, 4),
              a.f_balance_eot,
              0) as ������ģ,
       nvl(c.f_scale_eot, 0) as ���Ź�ģ,
       a.f_balance_agg as ��ģ���
  from tt_sr_scale_stage_m a, dim_sr_stage b, temp_bridge c
 where a.l_stage_id = b.l_stage_id
   and a.l_month_id = 201612
   and a.l_stage_id = c.l_stage_id(+)
   and a.l_month_id = c.l_month_id(+)
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 order by b.c_stage_code;

--��Ŀ���ȵĹ�ģ�˶�
with temp_bridge as
 (select t1.l_month_id, t1.l_proj_id, sum(t1.f_scale_eot) as f_scale_eot
    from tt_sr_scale_type_m t1, dim_pb_scale_type t2
   where t1.l_scatype_id = t2.l_scatype_id
     and t2.c_scatype_code = '62'
   group by t1.l_month_id, t1.l_proj_id)
select d.c_proj_code as ��Ŀ����,
 sum(a.f_increase_eot) / 100000000 as ����������ģ,
 sum(a.f_decrease_eot) / 100000000 as ������ٹ�ģ,
 sum(decode(substr(b.l_setup_date, 1, 4),
            substr(a.l_month_id, 1, 4),
            a.f_balance_eot,
            0)) / 100000000 as ������ģ,
 sum(nvl(c.f_scale_eot, 0)) / 100000000 as ���Ź�ģ,
 sum(a.f_balance_agg) / 100000000 as ��ģ���
  from tt_sr_scale_stage_m  a,
       dim_sr_stage         b,
       temp_bridge          c,
       dim_pb_project_basic d
 where a.l_stage_id = c.l_proj_id(+)
   and a.l_month_id = 201612
   and a.l_month_id = c.l_month_id(+)
   and a.l_proj_id = d.l_proj_id
   and a.l_stage_id = b.l_stage_id
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_proj_code
 order by d.c_proj_code;

--�ڴ���������˶�
select b.c_stage_code as �ڴα���,
       sum(case when c.c_ietype_code = 'XTGDBC' and d.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as �������й̶�����,
       sum(case when c.c_ietype_code = 'XTFDBC' and d.l_recog_flag = 0 then   a.f_planned_eoy else 0 end ) as �������и�������,
       sum(case when c.c_ietype_code= 'XTCGF' and d.l_recog_flag = 0 then  a.f_planned_eoy else  0 end) as �������вƹ˷�,
       sum(case when c.c_ietype_code_l2 = 'XTYXFY'and d.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as ����Ӫ������,
       sum(case when c.c_ietype_code = 'XTFXBC'and d.l_recog_flag = 0 then  a.f_planned_eoy else 0 end) as ����������б���,
       sum(case when c.c_ietype_code= 'XTFXCGF'and d.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as �������ƹ˷�,
       sum(case when c.c_ietype_code= 'TZZYFX'and d.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as ������Ӫ����
  from tt_sr_ie_stage_m a,
       dim_sr_stage     b,
       dim_pb_ie_type   c,
       dim_pb_ie_status d
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by b.c_stage_code;
 
--���˺������ȹ�ģ�˶�
select d.c_dept_code as ���ű���,
       d.c_dept_name as ��������,
       sum(a.f_scale_eot) as �ֳɺ��ģ
  from tt_pe_scale_stage_m a,
       dim_sr_stage        b,
       dim_pb_scale_type   c,
       dim_pb_department   d
 where a.l_stage_id = b.l_stage_id
   and a.l_scatype_id = c.l_scatype_id
   and a.c_object_type = 'BM'
   and a.l_object_id = d.l_dept_id
   and substr(b.l_setup_date, 1, 4) = substr(a.l_month_id, 1, 4)
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_dept_code, d.c_dept_name
 order by d.c_dept_code, d.c_dept_name;

--ĳ�����µ��ڴηֳɺ�����ģ��ϸ
select b.c_stage_code as �ڴα���,
       b.c_stage_name as �ڴ�����,
       sum(a.f_scale_eot) as �ֳɺ��ģ
  from tt_pe_scale_stage_m a,
       dim_sr_stage        b,
       dim_pb_scale_type   c,
       dim_pb_department   d
 where a.l_stage_id = b.l_stage_id
   and a.l_scatype_id = c.l_scatype_id
   and a.c_object_type = 'BM'
   and a.l_object_id = d.l_dept_id
   and substr(b.l_setup_date, 1, 4) = substr(a.l_month_id, 1, 4)
   and d.c_dept_code = '0_ms2003'
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by b.c_stage_code, b.c_stage_name
 order by b.c_stage_code, b.c_stage_name;

--���˺�Ա�����ȹ�ģ�˶�
select d.c_emp_code as Ա������,
       d.c_emp_name as Ա������,
       sum(a.f_scale_eot) as �ֳɺ��ģ
  from tt_pe_scale_stage_m a,
       dim_sr_stage        b,
       dim_pb_scale_type   c,
       dim_pb_employee   d
 where a.l_stage_id = b.l_stage_id
   and a.l_scatype_id = c.l_scatype_id
   and a.c_object_type = 'YG'
   and a.l_object_id = d.l_emp_id
   and substr(b.l_setup_date, 1, 4) = substr(a.l_month_id, 1, 4)
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_emp_code, d.c_emp_name
 order by d.c_emp_code, d.c_emp_name;

--���˺�����������˶�
select d.c_dept_code as ���ű���,
       d.c_dept_name as ��������,
       sum(case when c.c_ietype_code_l2 = 'XTBC' and e.l_recog_flag = 0 then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC', 'TZZYFX') then a.f_planned_eoy * -1 else 0 end) as �ֳɺ����б���,
       sum(case when c.c_ietype_code_l2 = 'XTCGF'and e.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as �ֳɺ�ƹ˷�,
       sum(case when  c.c_ietype_code_l2 = 'XTYXFY' and e.l_recog_flag = 0 then a.f_planned_eoy else  0 end) as �ֳɺ�Ƹ�����,
       sum(case when c.c_ietype_code_l1 = 'XTSR' and e.l_recog_flag = 1 then a.f_Planned_Eoy else 0 end) as ȷ������
  from tt_pe_ie_stage_m  a,
       dim_sr_stage      b,
       dim_pb_ie_type    c,
       dim_pb_department d,
       dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.c_object_type = 'BM'
   and a.l_object_id = d.l_dept_id
   and a.l_iestatus_id = e.l_iestatus_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_dept_code, d.c_dept_name
 order by d.c_dept_code, d.c_dept_name;
 
--���˺��ڴ���������˶�
select b.c_stage_code as �ڴα���,
       sum(case when c.c_ietype_code_l2 = 'XTBC'and e.l_recog_flag = 0 then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC', 'TZZYFX')and e.l_recog_flag = 0 then a.f_planned_eoy * -1 else 0 end) as �ֳɺ����б���,
       sum(case when c.c_ietype_code_l2 = 'XTCGF'and e.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as �ֳɺ�ƹ˷�,
       sum(case when c.c_ietype_code_l2='XTYXFY' and e.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as �ֳɺ�Ƹ�����,
       sum(case when c.c_ietype_code_l1= 'XTSR' and e.l_recog_flag = 1 then a.f_Planned_Eoy else 0 end) as ȷ������
  from tt_pe_ie_stage_m  a,
       dim_sr_stage      b,
       dim_pb_ie_type    c,
       dim_pb_department d,
       dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.c_object_type = 'BM'
   --and d.c_dept_code = '0_ms1501'
   and a.l_object_id = d.l_dept_id
   and a.l_iestatus_id = e.l_iestatus_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by b.c_stage_code 
 order by b.c_stage_code;

--���˺�����������˶�
select d.c_emp_code as ���ű���,
       d.c_emp_name as ��������,
       sum(case when c.c_ietype_code_l2 = 'XTBC' and e.l_recog_flag = 0 then a.f_planned_eoy when c.c_ietype_code in ('XTFXBC', 'TZZYFX') then a.f_planned_eoy * -1 else 0 end) as �ֳɺ����б���,
       sum(case when c.c_ietype_code_l2 = 'XTCGF'and e.l_recog_flag = 0 then a.f_planned_eoy else 0 end) as �ֳɺ�ƹ˷�,
       sum(case when  c.c_ietype_code_l2 = 'XTYXFY' and e.l_recog_flag = 0 then a.f_planned_eoy else  0 end) as �ֳɺ�Ƹ�����,
       sum(case when c.c_ietype_code_l1 = 'XTSR' and e.l_recog_flag = 1 then a.f_Planned_Eoy else 0 end) as ȷ������
  from tt_pe_ie_stage_m  a,
       dim_sr_stage      b,
       dim_pb_ie_type    c,
       dim_pb_employee d,
       dim_pb_ie_status  e
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.c_object_type = 'YG'
   and a.l_object_id = d.l_emp_id
   and a.l_iestatus_id = e.l_iestatus_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_emp_code, d.c_emp_name
 order by d.c_emp_code, d.c_emp_name;

--������Ͷ���
select b.c_proj_code, sum(a.f_balance_agg) / 100000000 as ��Ͷ���
  from tt_sr_fund_stage_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_month_id = 201612
   and c.c_busi_scope = '0'
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by b.c_proj_code
 order by b.c_proj_code;

--������Ӫ����
select sum(decode(d.c_ietype_code_l1, 'TZSR', a.f_planned_eoy, 0)) / 10000 as ��Ӫ����,
       sum(decode(d.c_ietype_code, 'TZZYFX', a.f_planned_eoy, 0)) / 10000 as ��Ӫ����,
       sum(case when d.c_ietype_code in('TZSY','TZLX','TZFX','TZWYJ') then a.f_planned_eoy else 0 end) / 10000 as ��Ӫ���벻����Ӫ����
  from tt_sr_ie_stage_m     a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_ie_type       d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
   and a.l_month_id = 201612
   and c.c_busi_scope = '0'
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;

--ȷ������
select b.c_stage_code,
       sum(case
             when c.c_ietype_code in ('XTGDBC', 'XTFDBC') then
              a.f_planned_eoy
             else
              0
           end) as �ļ��ȿ������б���
  from tt_sr_ie_stage_m a,
       dim_sr_stage     b,
       dim_pb_ie_type   c,
       dim_pb_ie_status d
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and d.l_recog_flag = 1
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id
 group by b.c_stage_code
 order by b.c_stage_code;
 
--������Ŀ��Ӫ����
select sum(case
             when c.c_ietype_code = 'TZZYFX' and d.l_recog_flag = 0 then
              a.f_planned_eoy
             else
              0
           end) as ������Ӫ����
  from tt_sr_ie_stage_m a,
       dim_sr_stage     b,
       dim_pb_ie_type   c,
       dim_pb_ie_status d
 where a.l_stage_id = b.l_stage_id
   and a.l_ietype_id = c.l_ietype_id
   and a.l_iestatus_id = d.l_iestatus_id
   and a.l_month_id = 201612
   and substr(b.l_effective_date, 1, 6) <= a.l_month_id
   and substr(b.l_expiration_date, 1, 6) > a.l_month_id;

--��Ӫ��Ŀ��Ӫ����
select sum(case
             when d.c_ietype_code = 'TZZYFX' and e.l_recog_flag = 0 then
              a.f_planned_eoy
             else
              0
           end) as ������Ӫ����
  from tt_sr_ie_stage_m     a,
       dim_pb_project_biz   b,
       dim_pb_project_basic c,
       dim_pb_ie_type       d,
       dim_pb_ie_status     e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and a.l_ietype_id = d.l_ietype_id
   and a.l_iestatus_id = e.l_iestatus_id
   and b.c_busi_scope = '0'
   and a.l_month_id = 201612
   and substr(c.l_effective_date, 1, 6) <= a.l_month_id
   and substr(c.l_expiration_date, 1, 6) > a.l_month_id; 

