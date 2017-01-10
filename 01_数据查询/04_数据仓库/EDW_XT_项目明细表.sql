--��Ŀ��Ϣ��ϸ
with temp_scale as
 (select t1.l_proj_id,
         t1.f_increase_eot,
         t1.f_decrease_eot,
         t1.f_balance_eot
    from tt_sr_scale_proj_m t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
     and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
     and t1.l_month_id = 201609),
temp_revenue as
 (select t1.l_proj_id,
         sum(case when t1.l_revtype_id = 2 and t1.l_revstatus_id = 1 then t1.f_actual_eot else 0 end) as f_new_xtbc,
         sum(case when t1.l_revtype_id = 2 and t1.l_revstatus_id = 2 then t1.f_actual_eot else 0 end) as f_exist_xtbc,
         sum(case when t1.l_revtype_id = 4 and t1.l_revstatus_id = 1 then t1.f_actual_eot else 0 end) as f_new_xtcgf,
         sum(case when t1.l_revtype_id = 4 and t1.l_revstatus_id = 2 then t1.f_actual_eot else 0 end) as f_exist_xtcgf
    from tt_sr_tstrev_proj_m t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t1.l_month_id >= substr(t2.l_effective_date, 1, 6)
     and t1.l_month_id < substr(t2.l_expiration_date, 1, 6)
     and t1.l_month_id = 201609
   group by t1.l_proj_id),
temp_fa as
 (select t1.l_proj_id, t1.f_scale_eot, t1.f_scale_agg
    from tt_po_rate_proj_d t1, dim_pb_project_basic t2
   where t1.l_proj_id = t2.l_proj_id
     and t2.l_effective_flag = 1
     and t1.l_day_id = 20160930)
select a.c_proj_code     as ��Ŀ����,
       a.c_proj_name     as ��Ŀ����,
       c.c_dept_name     as ���в���,
       g.c_emp_name      as ���о��� a.c_proj_phase_n as ��Ŀ�׶�,
       a.c_proj_status_n as ��Ŀ״̬,
       a.l_setup_date    as ��������,
       a.l_preexp_date   as Ԥ��������,
       a.l_expiry_date   as ��������,
       b.c_busi_scope_n  as ҵ��Χ,
       b.c_proj_type_n   as ��Ŀ����,
       --b.c_property_type_n as ��Ŀ�Ʋ�Ȩ����,
       b.c_func_type_n as ��������,
       --b.c_coop_type_n as ��������,
       b.c_trust_type_n    as ��������,
       b.c_manage_type_n   as ����ʽ,
       a.c_operating_way_n as ���з�ʽ,
       b.c_special_type_n  as ����ҵ������,
       b.c_fduse_way_n     as �ʽ����÷�ʽ,
       b.c_invest_indus_n  as Ͷ����ҵ,
       b.c_invest_dir_n    as Ͷ�ʷ���,
       --b.c_invest_way_n as Ͷ�ʷ�ʽ,
       d.f_increase_eot as ����������ģ,
       d.f_decrease_eot as ������ٹ�ģ,
       d.f_balance_eot as ��ǰ������ģ,
       f.f_scale_eot as FA�������й�ģ,
       f.f_scale_agg as FA�ۼ�ʵ�����й�ģ,
       e.f_new_xtbc as �������б���,
       e.f_exist_xtbc as �������б���,
       e.f_new_xtbc + e.f_exist_xtbc as �������б���,
       e.f_new_xtcgf as �������вƹ˷�,
       e.f_exist_xtcgf as �������вƹ˷�,
       e.f_new_xtcgf + e.f_exist_xtcgf as �������вƹ˷�
  from dim_pb_project_basic a,
       dim_pb_project_biz   b,
       dim_pb_department    c,
       temp_scale           d,
       temp_revenue         e,
       temp_fa              f,
       dim_pb_employee      g
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and a.l_tstmgr_id = g.l_emp_id
   and a.l_proj_id = d.l_proj_id(+)
   and a.l_proj_id = e.l_proj_id(+)
   and a.l_proj_id = f.l_proj_id(+)
   and a.l_effective_flag = 1
 order by a.l_setup_date;