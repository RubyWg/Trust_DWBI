--��Ŀ��������Ϊ��
select s.c_projcode  as ��Ŀ����,
       s.c_fullname  as ��Ŀ����,
       s.d_begdate   as ��Ŀ��ʼ����,
       s.d_enddate   as ��Ŀ��������,
       t.c_fundcode  as ��Ʒ����,
       t.c_fundname  as ��Ʒ����,
       t.d_issuedate as ��Ʒ��������,
       t.d_setupdate as ��Ʒ��������,
       t.d_enddate   as ��Ʒ��ֹ����,
       t.d_liqudate  as ��Ʒ��������
  from ta_fundinfo t, pm_projectinfo s
 where t.c_projcode = s.c_projcode
   and t.d_setupdate is null;

--�鿴�Ƿ�����ʷ����Ŀ�������뵱ǰ��Ч��Ŀ�����Բ�һ��
select t1.c_proj_code, t1.c_proj_name
  from (select a.c_proj_code,
               a.c_proj_name,
               b.c_Manage_Type,
               b.c_manage_type_n,
               b.c_proj_type,
               b.c_proj_type_n,
               b.c_func_type,
               b.c_func_type_n,
               b.c_affair_props,
               b.c_affair_props_n
          from dim_pb_project_basic a, dim_pb_project_biz b
         where a.l_effective_flag = 0
           and a.l_proj_id = b.l_proj_id) t1,
       (select a.c_proj_code,
               a.c_proj_name,
               b.c_Manage_Type,
               b.c_manage_type_n,
               b.c_proj_type,
               b.c_proj_type_n,
               b.c_func_type,
               b.c_func_type_n,
               b.c_affair_props,
               b.c_affair_props_n
          from dim_pb_project_basic a, dim_pb_project_biz b
         where a.l_effective_flag = 1
           and a.l_proj_id = b.l_proj_id) t2
 where t1.c_proj_code = t2.c_proj_code
   and dbms_utility.get_hash_value(t1.c_manage_type || t1.c_manage_type_n ||
                                   t1.c_proj_type || t1.c_proj_type_n ||
                                   t1.c_func_type || t1.c_func_type_n ||
                                   t1.c_affair_props || t1.c_affair_props_n,
                                   0,
                                   power(2, 30)) <>
       dbms_utility.get_hash_value(t2.c_manage_type || t2.c_manage_type_n ||
                                   t2.c_proj_type || t2.c_proj_type_n ||
                                   t2.c_func_type || t2.c_func_type_n ||
                                   t2.c_affair_props || t2.c_affair_props_n,
                                   0,
                                   power(2, 30));

--TA��FA��ģ�Ƚ�
--�����ձ�								 
select t1.c_proj_code   as ��Ŀ����,
       t1.c_proj_name   as ��Ŀ����,
       t1.l_setup_date  as ��������,
       t1.f_balance_eot as TA��ģ,
       t2.f_scale_eot   as FA��ģ,
       t2.c_proj_code   as ��Ŀ����,
       t2.c_proj_name   as ��Ŀ����
  from (select b.l_proj_id,b.c_proj_code,b.c_proj_name,b.l_setup_date,a.f_balance_eot
           from tt_sr_scale_proj_m a, dim_pb_project_basic b
          where a.l_proj_id = b.l_proj_id
            and a.l_month_id = 201610
            and substr(b.l_effective_date, 1, 6) <= 201610
            and substr(b.l_expiration_date, 1, 6) > 201610) t1 full outer join
        (select d.l_proj_id,d.c_proj_code,d.c_proj_name,d.l_setup_date,c.f_scale_eot
           from tt_po_rate_proj_d c, dim_pb_project_basic d
          where c.l_proj_id = d.l_proj_id
            and c.l_day_id = 20161031) t2 on t1.l_proj_id = t2.l_proj_id 
  where t1.f_balance_eot <> t2.f_scale_eot
order by t1.l_setup_date;
								   
--TA��FA��ģ�Ƚ�
select t1.c_proj_code   as ��Ŀ����,
       t1.c_proj_name   as ��Ŀ����,
       t1.l_setup_date  as ��������,
       t1.f_balance_agg as TA��ģ,
       t2.f_balance_agg as FA��ģ,
       t2.c_proj_code   as ��Ŀ����,
       t2.c_proj_name   as ��Ŀ����
  from (select b.l_proj_id,
               b.c_proj_code,
               b.c_proj_name,
               b.l_setup_date,
               sum(a.f_scale) as f_balance_agg
          from tt_sr_scale_flow_d   a,
               dim_pb_project_basic b,
               dim_sr_scale_type    c
         where a.l_proj_id = b.l_proj_id
           and a.l_scatype_id = c.l_scatype_id
           and C.C_SCATYPE_CLASS = 'XTHTGM'
           and a.l_change_date <= 20170303 --and b.c_proj_code = 'F658'
           and B.L_CY_ID = 1
         group by b.l_proj_id, b.c_proj_code, b.c_proj_name, b.l_setup_date) t1
  full outer join (select d.l_proj_id,
                          d.c_proj_code,
                          d.c_proj_name,
                          d.l_setup_date,
                          sum(a.f_balance) as f_balance_agg
                     from tt_to_accounting_flow_d a,
                          dim_to_subject          b,
                          dim_to_book             c,
                          dim_pb_project_basic    d
                    where a.l_subj_id = b.l_subj_id
                      and a.l_book_id = c.l_book_id
                      and c.l_proj_id = d.l_proj_id
                      and b.c_subj_code like '4001%'
                      and a.l_busi_date <= 20170303
                      and d.L_CY_ID = 1 --and d.c_proj_code = 'F658'
                    group by d.l_proj_id,
                             d.c_proj_code,
                             d.c_proj_name,
                             d.l_setup_date) t2
    on t1.l_proj_id = t2.l_proj_id
 where nvl(t1.f_balance_agg, 0) <> nvl(t2.f_balance_agg, 0)
 order by t1.l_setup_date;
 
--TA��FA��AM��ģ�Ƚ�
with temp_ta as
 (select a.l_proj_id,
         sum(a.f_balance_agg) as f_ta
    from tt_tc_scale_cont_m a, dim_pb_product b
   where a.l_prod_id = b.l_prod_id
     and a.l_month_id = 201610
     and substr(b.l_effective_date, 1, 6) <= 201610
     and substr(b.l_expiration_date, 1, 6) > 201610
   group by a.l_proj_id),
temp_fa as
 (select c.l_proj_id,
         sum(c.f_balance_agg) as f_fa
    from tt_to_operating_book_m c,dim_to_book c1
   where c.l_month_id = 201610 
     and c.l_book_id = c1.l_book_id
     and c1.l_effective_flag = 1
   group by c.l_proj_id),
temp_am as
 (select a.l_proj_id,
         sum(a.f_invest_agg) - sum(a.f_return_agg) as f_am
    from tt_ic_invest_cont_m a, dim_ic_contract b
   where a.l_cont_id = b.l_cont_id
     and substr(b.l_effective_date, 1, 6) <= 201610
     and substr(b.l_expiration_date, 1, 6) > 201610
     and a.l_month_id = 201610
   group by a.l_proj_id)
select t.l_proj_id,t.c_proj_code,t.c_proj_name,t.l_setup_date,temp_ta.f_ta, temp_fa.f_fa, temp_am.f_am
  from dim_pb_project_basic t,temp_ta, temp_fa, temp_am
 where t.l_proj_id = temp_ta.l_proj_id 
   and temp_ta.l_proj_id = temp_fa.l_proj_id(+)
   and temp_ta.l_proj_id = temp_am.l_proj_id(+);

--��Ʒ�мƻ���ʵ������
select c.c_proj_code as ��Ŀ����,
       c.c_proj_name as ��Ŀ����,
       c.l_setup_date as ��Ŀ��������,
       d.c_dept_name as ��������,
       b.c_prod_code as ��Ʒ����,
       sum(a.f_actual_agg) as ʵ������,
       sum(a.f_planned_agg) as �ƻ�����
  from tt_ic_ie_prod_m      a,
       dim_pb_product       b,
       dim_pb_project_basic c,
       dim_pb_department    d
 where a.l_prod_id = b.l_prod_id
   and a.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and a.l_ietype_id = 3
   and a.l_month_id = 201609
      --and c.c_proj_code = 'AVICTC2016X0247'
      --group by c.c_proj_code,c.c_proj_name,c.l_setup_date
   and a.f_planned_agg - a.f_actual_agg < 0
 group by c.c_proj_code,
          c.c_proj_name,
          c.l_setup_date,
          d.c_dept_name,
          b.c_prod_code
 order by c.l_setup_date desc, c.c_proj_code;

--�޷���������
select c.c_proj_code, c.c_proj_name, sum(a.f_midrev_int_eot)
  from tt_ic_midrev_proj_m a, dim_pb_project_biz b, dim_pb_project_basic c
 where a.l_proj_id = b.l_proj_id(+)
   and b.l_proj_id = c.l_proj_id
   and b.l_bankrec_sub is null
   and a.l_month_id = 201608
   and substr(c.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
   and substr(c.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
 group by c.c_proj_code, c.c_proj_name
having sum(a.f_midrev_int_eot) <> 0;