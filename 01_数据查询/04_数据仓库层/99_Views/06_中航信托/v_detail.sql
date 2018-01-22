create or replace view v_detail as
with temp_prod_scale as
 (select a.l_prod_id,
               a.l_proj_id,
               sum(t.f_balance_agg) as f_balance_agg,
               sum(t.f_increase_eot) as f_increase_eot,
               sum(decode(trunc(a.l_setup_date / 10000),
                          trunc(t.l_month_id /100),
                          t.f_balance_agg,
                          t.f_increase_eot)) as f_net_inc_eot,
               sum(decode(trunc(b.l_expiry_date / 10000),
                          trunc(t.l_month_id /100),
                          t.f_decrease_agg,
                          0)) as f_decrease_eot,
               sum(t.f_decrease_agg) as f_decrease_agg
          from dim_pb_product a,
               dim_pb_project_basic b,
               (select * from tt_tc_scale_cont_m where l_month_id = to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')) t
         where a.l_prod_id = t.l_prod_id(+)
           and a.l_proj_id = b.l_proj_id
           and substr(a.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
           and substr(a.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
         group by a.l_prod_id, a.l_proj_id, b.l_expiry_date),
temp_prod_revenue as
 (
  select tt.*,
  sum(tt.f_actual_xtbc)over(partition by tt.l_proj_id)  as f_proj_actual_xtbc,
  sum(tt.f_planned_xtbc)over(partition by tt.l_proj_id)  as f_proj_planned_xtbc,
  sum(tt.f_actual_xtcgf)over(partition by tt.l_proj_id)  as f_proj_actual_xtcgf,
  sum(tt.f_planned_xtcgf)over(partition by tt.l_proj_id)  as f_proj_planned_xtcgf  from (
  select t.l_prod_id,
         t.l_proj_id,
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_actual_agg, 0)), 0) as f_actual_xtbc, --�ۼ���֧�����б���
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_actual_eot, 0)), 0) as f_actual_xtbc_eot, --������֧�����б���
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_actual_agg, 0)), 0) as f_actual_xtcgf, --�ۼ���֧�����вƹ˷�
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_actual_eot, 0)), 0) as f_actual_xtcgf_eot, --������֧�����вƹ˷�
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTBC', t.f_planned_agg, 0)), 0) as f_planned_xtbc, --�ۼƼƻ����б���
       nvl(sum(decode(t1.c_ietype_code_l2, 'XTCGF', t.f_planned_agg, 0)), 0) as f_planned_xtcgf, --�ۼƼƻ��ƹ˷�
       nvl(sum(decode(t1.c_ietype_code, 'XTBLBC', t.f_planned_agg, 0)), 0) as f_planned_xtblbc --�ۼƼƻ����б��������
  from tt_ic_ie_prod_m t, dim_pb_ie_type t1,dim_pb_product t2
 where t.l_month_id = to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and t.l_ietype_id = t1.l_ietype_id
   and t.l_prod_id = t2.l_prod_id
   and substr(t2.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(t2.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
 group by t.l_prod_id,t.l_proj_id) tt),
temp_benefical_right as
 (select t.l_prod_id,
       min(t.f_expect_field) as f_min_field,
       max(t.f_expect_field) as f_max_field
  from dim_tc_beneficial_right t, dim_pb_product t1
 where t.l_prod_id = t1.l_prod_id
   and substr(t1.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(t1.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
 group by t.l_prod_id),
temp_sale_way as
 (select t.l_prod_id,
       wmsys.wm_concat(distinct t.c_sale_way_n) as c_sale_way,
       wmsys.wm_concat(distinct case
                         when c.c_proj_type = '1' then
                          b.c_cust_name
                         else
                          null
                       end) as c_benefic_name
  from dim_tc_contract    t,
       dim_pb_product     a,
       dim_ca_customer    b,
       dim_pb_project_biz c
 where t.l_prod_id = a.l_prod_id
   and t.l_benefic_id = b.l_cust_id(+)
   and a.l_proj_id = c.l_proj_id
   and substr(t.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(t.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
 group by t.l_prod_id),
temp_ic_rate as
 (select t.l_prod_id,
       min(t.f_rate) as f_min_rate,
       max(t.f_rate) as f_max_rate
  from dim_ic_rate t, dim_pb_product t1
 where t.l_prod_id = t1.l_prod_id
   and substr(t1.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(t1.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
 group by t.l_prod_id),
temp_fa as (
select a.c_book_code,
       b.l_prod_id,
       a.l_proj_id,
       sum(case
             when c.c_subj_code_l1 = '4001' and c.c_subj_code_l2 <> '400100' then
              t.f_balance_agg
             else
              0
           end) as fa_balance,
       sum(case
             when c.c_subj_code_l1 in ('1101', '1111','1303','1501','1503','1531','1541','1122','1511') then
              t.f_balance_agg
             else
              0
           end) as tz_balance
  from tt_to_accounting_subj_m t,
       dim_to_book             a,
       dim_pb_product          b,
       dim_to_subject          c
 where t.l_book_id = a.l_book_id
   and a.l_prod_id = b.l_prod_id
   and t.l_subj_id = c.l_subj_id
   and t.l_month_id = to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and c.l_effective_flag = 1
 group by a.c_book_code,b.l_prod_id,a.l_proj_id),
temp_fa_book as (
select *
  from (select row_number() over(partition by b.l_proj_id,a.l_prod_id order by b.c_book_code desc) as l_rn,
               a.l_prod_id,
               b.c_book_code
          from dim_pb_product a, dim_to_book b
         where a.l_proj_id = b.l_proj_id )
 where l_rn = 1
),
temp_fa_book_mprod as (
select a.l_prod_id, b.c_book_code
  from dim_pb_product a, dim_to_book b
 where a.l_mprod_id = b.l_prod_id
   and a.l_mprod_id <> 0
   and substr(b.l_effective_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(b.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
)
select nvl(p.c_book_code,nvl(n.c_book_code,m.c_book_code)) as "���ױ��",
       b.c_proj_code as "��Ŀ���" ,
       b.c_name_full as "��Ŀ����" ,
       d.c_dept_name as "ҵ����" ,
       a.c_manage_type_n as "��Ʒ��������" ,
       c.c_proj_type_n as "��Ŀ����" ,
       a.c_func_type_n as "��Ʒ���ܷ���" ,
       a.c_invest_indus_n as "��Ʒʵ��Ͷ��" ,
       to_date (b.l_setup_date ,'yyyymmdd') as "��Ŀ��ʼ����" ,
       to_date (b.l_expiry_date ,'yyyymmdd') as "��Ŀ��ֹ����" ,
       to_date (b.l_preexp_date ,'yyyymmdd') as "��ĿԤ�Ƶ���" ,
       case when nvl( b.l_expiry_date, 20991231 ) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymmdd') then '����' else '����' end as "��Ŀ״̬" ,
       decode( c.l_pool_flag,0 , '��' , 1 , '��' , null ) as "�Ƿ��ʽ��" ,
       decode( c.c_special_type, 'A', '��' ,'��' ) as "�Ƿ�С��" ,
       a.c_prod_code as "��Ʒ����" ,
       to_date (a.l_setup_date ,'yyyymmdd') "��Ʒ��ʼ����" ,
       to_date (a.l_expiry_date,'yyyymmdd') "��Ʒ��ֹ����" ,
       to_date (a.l_preexp_date ,'yyyymmdd') "��Ʒ��������" ,
       --g.c_inst_name as "��һ�ʽ���Դ(BULU)" ,
       --j.c_sale_way as "�����ʽ���������(TA)" ,
       j.c_benefic_name as "��һ��ͬ������" ,
       (case when i.f_min_field is null and i.f_max_field is null then null else to_char(i.f_min_field * 100 , 'fm9999999990.00' ) || '%-' || to_char (i.f_max_field * 100 ,'fm9999999990.00' )|| '%' end) as Ԥ�������� ,
       a.f_trustpay_rate,
       decode( a.l_tot_flag, 0, '��' , 1 , '��' , null ) as "�Ƿ�TOT" ,
       nvl( e.f_balance_agg, 0) as ��Ʒ�������,
       nvl( decode ( a.c_struct_type , '0', e.f_balance_agg , 0), 0 ) as ���� ,
       nvl( decode ( a.c_struct_type , '2', e.f_balance_agg , 0), 0 ) as �Ӻ� ,
       nvl( decode ( c.l_pool_flag , 1, 0 , e.f_decrease_agg ), 0) as �ۼƻ��� ,
       nvl( decode ( c.l_pool_flag , 1, 0 , e.f_net_inc_eot ), 0) as ����������ģ ,
       nvl( e.f_decrease_eot,0 ) as ���������ģ ,
       m.fa_balance as FA��ģ ,
       decode(nvl(sum(e.f_balance_agg)over(partition by a.l_proj_id),0),nvl(sum(nvl(m.fa_balance,0))over(partition by a.l_proj_id),0),'��','��') as �Ƿ�һ�� ,
       m.tz_balance as Ͷ����� ,
       to_char ((decode(k.f_min_rate,null,null,k.f_min_rate*100)), 'fm9999999990.00' )|| (decode(k.f_min_rate,null,null,'%')) as ��Ʒ���б����� ,
       f.f_planned_xtbc + f.f_planned_xtcgf as ��ͬ������ ,
       f.f_planned_xtbc as ���б��� ,
       f.f_planned_xtblbc as ���б�������� ,
       f.f_actual_xtbc as �ۼ�֧�����б��� ,
       (case when f.f_proj_planned_xtbc - f.f_proj_actual_xtbc < 0 then 0 else f.f_planned_xtbc - f.f_actual_xtbc end ) as ��δ֧�����б��� ,
       f.f_planned_xtcgf as ������ʷ� ,
       f.f_actual_xtcgf as �ۼ���֧��������ʷ� ,
       (case when f.f_proj_planned_xtcgf - f.f_proj_actual_xtcgf < 0 then 0 else f.f_planned_xtcgf - f.f_actual_xtcgf end ) as ��δ֧��������ʷ� ,
       f.f_actual_xtbc_eot as ����֧�����б��� ,
       f.f_actual_xtcgf_eot as ������֧��������ʷ�,
       decode(c.l_openend_flag,1,'��','��') as "�Ƿ񿪷�ʽ"
  from dim_pb_product       a ,
       dim_pb_project_basic b ,
       dim_pb_project_biz   c ,
       dim_pb_department    d ,
       temp_prod_scale     e ,
       temp_prod_revenue   f ,
       dim_pb_institution   g ,
       temp_benefical_right i ,
       temp_sale_way        j ,
       temp_ic_rate         k ,
       temp_fa              m,
       temp_fa_book         n,
       temp_fa_book_mprod   p
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = c.l_proj_id
   and b.l_dept_id = d.l_dept_id (+)
   and c.l_bankrec_ho = g.l_inst_id (+)
   and a.l_prod_id = e.l_prod_id (+)
   and a.l_prod_id = f.l_prod_id (+)
   and substr( b.l_effective_date,1 , 6 ) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr( b.l_expiration_date,1 , 6 ) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and a.l_prod_id = i.l_prod_id (+)
   and a.l_prod_id = j.l_prod_id (+)
   and a.l_prod_id = k.l_prod_id (+)
   and a.l_prod_id = m.l_prod_id (+)
   and a.l_prod_id = n.l_prod_id(+)
   and a.l_prod_id = p.l_prod_id(+)
   and to_date(a.l_setup_date,'yyyymmdd') >= To_Date('01-01-2000', 'dd-mm-yyyy')
order by b.l_setup_date , b.c_proj_code , m.c_book_code , a.c_prod_code;
