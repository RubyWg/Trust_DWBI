--�ʽ�������ϸ�ױ�
with temp_cont_scale as (
select t.l_month_id,
       a.l_cont_id,
       b.l_prod_id,
       b.l_proj_id,
       sum(t.f_balance_agg) f_agg,
       sum(decode(trunc(b.l_setup_date / 10000), 2016, t.f_balance_agg, t.f_invest_eot)) f_inc_eot,
       sum(t.f_return_agg) f_dec_agg
  from tt_ic_invest_cont_m t, dim_ic_contract a, dim_pb_product b
 where t.l_cont_id = a.l_cont_id
   and a.l_prod_id = b.l_prod_id
   and t.l_month_id =
       to_char(To_Date('31-12-2016', 'dd-mm-yyyy'), 'yyyymm')
   and a.l_effective_date <= 20161231
   and a.l_expiration_date > 20161231
 group by t.l_month_id, a.l_cont_id, b.l_prod_id, b.l_proj_id),
temp_zc_fa as (
select distinct t1.l_prod_id,
                t1.fa_balance,
                t1.tz_balance,
                t2.ta_balance,
                tz_balance_xd,
                (case when nvl(t1.tz_balance, 0) - nvl(t2.ta_balance, 0) = 0 then '��' else  '��' end) as f_equal
  from (select b.l_prod_id,
               sum(case when c.c_subj_code_l1 = '4001' and c.c_subj_code_l2 <> '400100' then t.f_balance_agg else 0 end) as fa_balance,
               sum(case when c.c_subj_code_l1 in ('1101', '1111', '1303', '1501', '1503', '1531', '1541', '1122', '1511') then t.f_balance_agg else 0 end) as tz_balance,
               sum(case when c.c_subj_code_l1 in ('1303') then t.f_balance_agg else 0 end) as tz_balance_xd
          from tt_to_accounting_subj_m t,
               dim_to_book             a,
               dim_pb_product          b,
               dim_to_subject          c
         where t.l_book_id = a.l_book_id
           and a.l_prod_id = b.l_prod_id
           and t.l_subj_id = c.l_subj_id
           and substr(c.l_Effective_Date, 1, 6) <= t.l_month_id
           and substr(c.l_expiration_date, 1, 6) > t.l_month_id
           and t.l_month_id =
               to_char(To_Date('31-12-2016', 'dd-mm-yyyy'), 'yyyymm')
         group by b.l_prod_id) t1,
       (select a.l_prod_id,
               sum(a.f_agg) over(partition by a.l_proj_id) as ta_balance
          from temp_cont_scale a) t2
 where t1.l_prod_id = t2.l_prod_id)
select h.c_book_code as "���ױ��(FA)",
       c.c_proj_code as "��Ŀ���(TCMP)",
       c.c_name_full as "��Ŀ����(TCMP)",
       i.c_dept_name as "ҵ����(TCMP)",
       d.c_manage_type_n as "��������(TCMP)",
       d.c_proj_type_n as "��Ŀ����(TCMP)",
       d.c_func_type_n as "���ܷ���(BULU)",
       d.c_invest_indus_n"��Ŀʵ��Ͷ��(BULU)",
       to_date(c.l_setup_date, 'yyyymmdd') as "��Ŀ��ʼ����(TCMP)",
       to_date(c.l_expiry_date, 'yyyymmdd') as "��Ŀ��ֹ����(TCMP)",
       to_date(c.l_preexp_date, 'yyyymmdd') as "��ĿԤ�Ƶ���(TCMP)",
       case
         when nvl(substr(c.l_expiry_date, 1, 6), 209912) > 201612 then
          '����'
         else
          '����'
       end as "��Ŀ״̬(TCMP)",
       decode(d.l_pool_flag, 0, '��', 1, '��', null) as "�Ƿ��ʽ��(BULU)",
       decode(d.c_special_type, 'A', '��', '��') as "�ջݽ���(TCMP)",
       decode(d.l_pitch_flag, 0, '��', 1, '��', null) as "�Ƿ��ڳ���(TCMP)",
       a.c_cont_code as "��ͬ����(AM)",
       a.c_cont_name as "��ͬ����(AM)",
       to_date(a.l_begin_date, 'yyyymmdd') as "��ͬ��ʼ��(AM)",
       to_date(a.l_expiry_date, 'yyyymmdd') as "��ͬ��ֹ��(AM)",
       a.c_busi_type_n as "��ͬ����(AM)",
       a.c_invest_indus_n as "��ͬʵ��Ͷ��(BULU)",
       a.c_real_party as "ʵ�ʽ��׶���(BULU)",
       g.c_party_name as "��ͬ���׶���(AM)",
       a.c_invest_way_n as "Ͷ�ʷ�ʽ(BULU)",
       a.c_fduse_way_n as "�ʽ���;���˳���ʽ(BULU)",
       f.c_indus_name as "Ͷ����ҵ(BULU)",
       e.c_prov_name as "�ʽ�����ʡ��(BULU)",
       e.c_city_name as "�ʽ����ó���(BULU)",
       a.f_cost_rate as "���ʳɱ�(AM)",
       decode(d.l_pitch_flag, 0, t1.f_agg, 1, t2.tz_balance, 0) as "Ͷ�ʺ�ͬ��ģ",
       t1.f_inc_eot as "����������ģ",
       t1.f_dec_agg as "�ۼƷ���",
       count(a.c_cont_code) over(partition by h.c_book_code),
       round(t2.tz_balance / count(a.c_cont_code)
             over(partition by h.c_book_code),
             2) as "FAͶ�ʹ�ģ",
       t2.f_equal as "�Ƿ���FAһ��",
       null as "�������(BULU)",
       null as "�Ƿ�ǩ����ս�Ժ���Э��(BULU)",
       null as "��֤ȯͶ����ҵ(BULU)",
       null as "��֤ȯͶ�ʷ�ʽ(BULU)",
       null as "��˾ս��ҵ��(BULU)",
       null as "PPP��������(BULU)",
       null as "PPP��Ŀ����(BULU)",
       null as "PPP��Ŀ������(BULU)",
       null as "PPP��Ҫ������Դ(BULU)",
       null as "����������(BULU)",
       null as "��ɫ��������(BULU)",
       null as "�ջݽ��ڷ�����(BULU)",
       null as "�ջݽ���ҵ������(BULU)"
  from temp_cont_scale             t1 ,
       temp_zc_fa                  t2 ,
       dim_ic_contract             a ,
       dim_pb_product              b ,
       dim_pb_project_basic        c ,
       dim_pb_project_biz          d ,
       dim_pb_area                 e ,
       dim_pb_industry             f ,
       dim_ic_counterparty         g ,
       dim_to_book                 h ,
       dim_pb_department           i
 where t1.l_prod_id = t2.l_prod_id (+)
   and t1.l_cont_id = a.l_cont_id
   and a.l_prod_id = b.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_fduse_area = e.l_area_id (+)
   and a.l_invindus_id = f.l_indus_id (+)
   and a.l_party_id = g.l_party_id (+)
   and a.l_prod_id = h.l_prod_id (+)
   and c.l_dept_id = i.l_dept_id (+)
   and ( nvl( d.c_special_type,'0' ) <> 'A' or nvl(a.c_busi_type ,'0') <> '1' )
   and substr(c.l_Effective_Date,1,6) <= t1.l_month_id
   and substr(c.l_expiration_date,1,6) > t1.l_month_id
 union all
select max (h.c_book_code ) as "���ױ��(FA)" ,
       max( c.c_proj_code) as "��Ŀ���(TCMP)" ,
       max( c.c_name_full) as "��Ŀ����(TCMP)" ,
       max( i.c_dept_name) as "ҵ����(TCMP)" ,
       max( d.c_manage_type_n) as "��������(TCMP)" ,
       max( d.c_proj_type_n) as "��Ŀ����(TCMP)" ,
       max( d.c_func_type_n) as "���ܷ���(BULU)" ,
       max( d.c_invest_indus_n) as "��Ŀʵ��Ͷ��(BULU)" ,
       to_date (max( c.l_setup_date) ,'yyyymmdd' ) as "��Ŀ��ʼ����(TCMP)" ,
       to_date (max( c.l_expiry_date) ,'yyyymmdd' ) as "��Ŀ��ֹ����(TCMP)" ,
       to_date (max( c.l_preexp_date) ,'yyyymmdd' ) as "��ĿԤ�Ƶ���(TCMP)" ,
       max( case when nvl( substr ( c.l_expiry_date ,1 , 6), 209912 ) > 201612 then '����' else '����' end ) as "��Ŀ״̬(TCMP)" ,
       max( decode( d.l_pool_flag ,0 , '��' , 1, '��' , null )) as "�Ƿ��ʽ��(BULU)" ,
       max( decode( d.c_special_type , 'A', '��', '��' )) as "�ջݽ���(TCMP)" ,
       max( decode( d.l_pitch_flag, 0 , '��' , 1 , '��' , null )) as "�Ƿ��ڳ���(TCMP)" ,
       'XEDK' as "��ͬ����(AM)" ,
       'С������ͬ' as "��ͬ����(AM)" ,
       to_date (min( a.l_begin_date),'yyyymmdd' ) as "��ͬ��ʼ��(AM)" ,
       to_date (max( a.l_expiry_date), 'yyyymmdd') as "��ͬ��ֹ��(AM)" ,
       max( a.c_busi_type_n) as "��ͬ����(AM)" ,
       '����' as "��ͬʵ��Ͷ��(BULU)" ,
       'С��ר�ö��ַ���' as "ʵ�ʽ��׶���(BULU)" ,
       'С��ר�ö��ַ���' as "��ͬ���׶���(AM)" ,
       max( a.c_invest_way_n) as "Ͷ�ʷ�ʽ(BULU)" ,
       max( a.c_fduse_way_n) as "�ʽ���;���˳���ʽ(BULU)" ,
       max( f.c_indus_name) as "Ͷ����ҵ(BULU)" ,
       max( e.c_prov_name) as "�ʽ�����ʡ��(BULU)" ,
       max( e.c_city_name) as "�ʽ����ó���(BULU)" ,
       max( a.f_cost_rate) as "���ʳɱ�(AM)" ,
       sum( t2.tz_balance_xd) as "Ͷ�ʺ�ͬ��ģ" ,
       sum( t1.f_inc_eot) as "����������ģ" ,
       sum( t1.f_dec_agg) as "�ۼƷ���" ,
       null,
       sum( t2.tz_balance_xd) as "FAͶ�ʹ�ģ",
       '��' as "�Ƿ���FAһ��" ,
       null as "�������(BULU)" ,
       null as "�Ƿ�ǩ����ս�Ժ���Э��(BULU)" ,
       null as "��֤ȯͶ����ҵ(BULU)" ,
       null as "��֤ȯͶ�ʷ�ʽ(BULU)" ,
       null as "��˾ս��ҵ��(BULU)" ,
       null as "PPP��������(BULU)" ,
       null as "PPP��Ŀ����(BULU)" ,
       null as "PPP��Ŀ������(BULU)" ,
       null as "PPP��Ҫ������Դ(BULU)" ,
       null as "����������(BULU)" ,
       null as "��ɫ��������(BULU)" ,
       null as "�ջݽ��ڷ�����(BULU)" ,
       null as "�ջݽ���ҵ������(BULU)"
  from temp_cont_scale             t1 ,
       temp_zc_fa                  t2 ,
       dim_ic_contract             a ,
       dim_pb_product              b ,
       dim_pb_project_basic        c ,
       dim_pb_project_biz          d ,
       dim_pb_area                 e ,
       dim_pb_industry             f ,
       dim_ic_counterparty         g ,
       dim_to_book                 h ,
       dim_pb_department           i
 where t1.l_prod_id = t2.l_prod_id (+)
   and t1.l_cont_id = a.l_cont_id
   and a.l_prod_id = b.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and c.l_proj_id = d.l_proj_id
   and a.l_fduse_area = e.l_area_id (+)
   and a.l_invindus_id = f.l_indus_id (+)
   and a.l_party_id = g.l_party_id (+)
   and a.l_prod_id = h.l_prod_id (+)
   and c.l_dept_id = i.l_dept_id (+)
   and d.c_special_type = 'A' and a.c_busi_type = '1'
 group by c.c_proj_code ;
