--�ʽ����õױ��ѯ���--��   
select v4."���ױ��(FA)",
       v1."��Ŀ���(TCMP)",
       v1."��Ŀ����(TCMP)",
       v1."ҵ����(TCMP)",
       v1."��������(TCMP)",
       v1."��Ŀ����(TCMP)",
       v1."���ܷ���(BULU)",
       v1."��Ŀʵ��Ͷ��(BULU)",
       v1."��Ŀ��ʼ����(TCMP)",
       v1."��Ŀ��ֹ����(TCMP)",
       v1. "��ĿԤ�Ƶ���(TCMP)",
       v1."��Ŀ״̬(TCMP)",
       v1."�Ƿ��ʽ��(BULU)",
       v1."�ջݽ���(TCMP)",
       v1."�Ƿ��ڳ���(TCMP)",
       v2."��ͬ����(AM)",
       v2."��ͬ����(AM)",
       v2."��ͬ��ʼ��(AM)",
       v2."��ͬ��ֹ��(AM)",
       v2."��ͬ����(AM)",
       v2."��ͬʵ��Ͷ��(BULU)",
       v2."ʵ�ʽ��׶���(BULU)",
       v2."��ͬ���׶���(AM)",
       v2."Ͷ�ʷ�ʽ(BULU)",
       v2."�ʽ���;(BULU)",
       v2."�˳���ʽ(BULU)",
       v2."Ͷ����ҵ(BULU)",
       v2."�ʽ�����ʡ��(BULU)",
       v2."�ʽ����ó���(BULU)",
       v2."���ʳɱ�(AM)",
       v3."Ͷ�ʺ�ͬ��ģ",
       v3."����������ģ",
       v3."�ۼƷ���",
       decode(v2.l_cont_id,null,v4.f_balance_zc,v3.f_invest_ratio*v4.f_balance_zc) as "FAͶ�ʹ�ģ",
       decode(sum(nvl(v3.Ͷ�ʺ�ͬ��ģ,0))over(partition by v1.l_proj_id),sum(nvl(v4.f_balance_zc,0))over(partition by v1.l_proj_id)/nvl(count(v4.f_balance_zc)over(partition by v1.l_proj_id),1),'��','��') "�Ƿ���FAһ��",
       v2."�������(BULU)",
       v2."�Ƿ�ǩ����ս�Ժ���Э��(BULU)",
       v2."��֤ȯͶ����ҵ(BULU)",
       v2."��֤ȯͶ�ʷ�ʽ(BULU)",
       v2."��˾ս��ҵ��(BULU)",
       v2."PPP��������(BULU)",
       v2."PPP��Ŀ����(BULU)",
       v2."PPP��Ŀ������(BULU)",
       v2."PPP��Ҫ������Դ(BULU)",
       v2."����������(BULU)",
       v2."��ɫ��������(BULU)",
       v2."�ջݽ��ڷ�����(BULU)",
       v2."�ջݽ���ҵ������(BULU)",
       v2. "������������"
  from v_pb_proj_info v1,v_to_balance_proj_m v4, v_ic_cont_info v2,v_ic_invest_cont_m v3
 where v1.l_proj_id = v4.l_proj_id
   and v1.l_prod_id = v4.l_prod_id
   and v1.l_proj_id = v2.l_proj_id(+)
   and v1.l_prod_id = v2.l_prod_id(+)
   and v2.l_cont_id = v3.l_cont_id(+);

--20170315֮ǰ
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
           and c.l_effective_flag = 1
           and t.l_month_id = to_char(To_Date('31-12-2016', 'dd-mm-yyyy'), 'yyyymm')
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
       case  when nvl(substr(c.l_expiry_date, 1, 6), 209912) > 201612 then '����' else '����' end as "��Ŀ״̬(TCMP)",
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
       --decode(d.l_pitch_flag, 0, t1.f_agg, 1, t2.tz_balance, 0) as "Ͷ�ʺ�ͬ��ģ",
       decode(d.c_special_type,'A',0,t1.f_agg)as "Ͷ�ʺ�ͬ��ģ",
       t1.f_inc_eot as "����������ģ",
       t1.f_dec_agg as "�ۼƷ���",
       count(a.c_cont_code) over(partition by h.c_book_code),
       decode(d.c_special_type,'A',0,round(t2.tz_balance / count(a.c_cont_code) over(partition by h.c_book_code), 2)) as "FAͶ�ʹ�ģ",
       t2.f_equal as "�Ƿ���FAһ��",
       a.c_coop_partner as "�������(BULU)",
       a.l_strategic_flag as "�Ƿ�ǩ����ս�Ժ���Э��(BULU)",
       null as "��֤ȯͶ����ҵ(BULU)",
       null as "��֤ȯͶ�ʷ�ʽ(BULU)",
       a.c_special_type_n as "��˾ս��ҵ��(BULU)",
       a.c_fiscal_revenue_n as "PPP��������(BULU)",
       decode(a.c_special_type,'7',a.c_subspecial_type_n,null) as "PPP��Ŀ����(BULU)",
       a.c_leading_party as "PPP��Ŀ������(BULU)",
       a.c_repay_way_n as "PPP��Ҫ������Դ(BULU)",
       decode(a.c_special_type,'4',a.c_subspecial_type_n,null) as "����������(BULU)",
       decode(a.c_special_type,'5',a.c_subspecial_type_n,null) as "��ɫ��������(BULU)",
       a.c_servicer as "�ջݽ��ڷ�����(BULU)",
       decode(a.c_special_type,'1',a.c_subspecial_type_n,null) as "�ջݽ���ҵ������(BULU)"
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
   and (nvl( d.c_special_type,'0' ) <> 'A' OR (nvl( d.c_special_type,'0' ) = 'A' and a.c_busi_type=  '1')) --��ȡС���Ǵ���ĺ�ͬ
   and a.c_cont_type <> '99'--��ȡ�����ͬ
   and substr(c.l_Effective_Date,1,6) <= t1.l_month_id
   and substr(c.l_expiration_date,1,6) > t1.l_month_id
union all
select t5.c_book_code as "���ױ��(FA)",
       t2.c_proj_code as "��Ŀ���(TCMP)",
       t2.c_name_full as "��Ŀ����(TCMP)",
       t4.c_dept_name as "ҵ����(TCMP)",
       t3.c_manage_type_n as "��������(TCMP)",
       t3.c_proj_type_n as "��Ŀ����(TCMP)",
       t3.c_func_type_n as "���ܷ���(BULU)",
       t3.c_invest_indus_n as "��Ŀʵ��Ͷ��(BULU)",
       to_date(t2.l_setup_date, 'yyyymmdd') as "��Ŀ��ʼ����(TCMP)",
       to_date(t2.l_expiry_date, 'yyyymmdd') as "��Ŀ��ֹ����(TCMP)",
       to_date(t2.l_preexp_date, 'yyyymmdd') as "��ĿԤ�Ƶ���(TCMP)",
       case when nvl(substr(t2.l_expiry_date, 1, 6), 209912) > 201612 then  '����' else  '����' end as "��Ŀ״̬(TCMP)",
       decode(t3.l_pool_flag, 0, '��', 1, '��', null) as "�Ƿ��ʽ��(BULU)",
       decode(t3.c_special_type, 'A', '��', '��') as "�ջݽ���(TCMP)",
       decode(t3.l_pitch_flag, 0, '��', 1, '��', null) as "�Ƿ��ڳ���(TCMP)",
       substr(t1.c_cont_code,1,4) as "��ͬ����(AM)",
       decode(substr(t1.c_cont_code,1,4),'XEDK','С�����','����Ͷ��') as "��ͬ����(AM)",
       null as "��ͬ��ʼ��(AM)",
       null as "��ͬ��ֹ��(AM)",
       null as "��ͬ����(AM)",
       null "��ͬʵ��Ͷ��(BULU)",
       null "ʵ�ʽ��׶���(BULU)",
       null "��ͬ���׶���(AM)",
       null as "Ͷ�ʷ�ʽ(BULU)",
       null as "�ʽ���;���˳���ʽ(BULU)",
       null as "Ͷ����ҵ(BULU)",
       null as "�ʽ�����ʡ��(BULU)",
       null as "�ʽ����ó���(BULU)",
       null as "���ʳɱ�(AM)",
       t6.f_balance_agg as "Ͷ�ʺ�ͬ��ģ",
       null as "����������ģ",
       null as "�ۼƷ���",
       null,
       t7.tz_balance as "FAͶ�ʹ�ģ",
       decode(t6.f_balance_agg,t7.tz_balance,'��','��') as "�Ƿ���FAһ��",
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
  from dim_ic_contract      t1,
       dim_pb_project_basic t2,
       dim_pb_project_biz   t3,
       dim_pb_department    t4,
       dim_to_book          t5,
       tt_ic_invest_cont_m  t6,
       temp_zc_fa           t7
 where t1.c_cont_type = '99'
   and t1.l_proj_id = t2.l_proj_id
   and t2.l_proj_id = t3.l_proj_id
   and t2.l_dept_id = t4.l_dept_id
   and t1.l_prod_id = t5.l_prod_id(+)
   and t1.l_cont_id = t6.l_cont_id
   and t2.l_proj_id = t6.l_proj_id
   and t1.l_prod_id = t7.l_prod_id(+)
   and t1.l_effective_flag = 1
   and t6.l_month_id = 201612;
     
create or replace view v_zhxt_zjjjdb as
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
       case when nvl(substr(c.l_expiry_date, 1, 6), 209912) > 201612 then  '����' else '����' end as "��Ŀ״̬(TCMP)",
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
       j.f_balance_agg as "Ͷ�ʺ�ͬ��ģ",
       j.f_invest_eot as "����������ģ",
       j.f_return_agg as "�ۼƷ���",
       --count(a.c_cont_code) over(partition by h.c_book_code),
       k.f_balance_zc,
       j.f_invest_ratio,
       k.f_balance_zc*j.f_invest_ratio "FAͶ�ʹ�ģ",
       null as "�Ƿ���FAһ��",
       a.c_coop_partner as "�������(BULU)",
       a.l_strategic_flag as "�Ƿ�ǩ����ս�Ժ���Э��(BULU)",
       null as "��֤ȯͶ����ҵ(BULU)",
       null as "��֤ȯͶ�ʷ�ʽ(BULU)",
       a.c_special_type_n as "��˾ս��ҵ��(BULU)",
       a.c_fiscal_revenue_n as "PPP��������(BULU)",
       decode(a.c_special_type, '7', a.c_subspecial_type_n, null) as "PPP��Ŀ����(BULU)",
       a.c_leading_party as "PPP��Ŀ������(BULU)",
       a.c_repay_way_n as "PPP��Ҫ������Դ(BULU)",
       decode(a.c_special_type, '4', a.c_subspecial_type_n, null) as "����������(BULU)",
       decode(a.c_special_type, '5', a.c_subspecial_type_n, null) as "��ɫ��������(BULU)",
       a.c_servicer as "�ջݽ��ڷ�����(BULU)",
       decode(a.c_special_type, '1', a.c_subspecial_type_n, null) as "�ջݽ���ҵ������(BULU)",
       a.c_gov_level_n as "������������"
  from dim_pb_project_basic c,
       dim_pb_project_biz   d,
       dim_ic_contract      a,
       dim_pb_product       b,
       dim_pb_area          e,
       dim_pb_industry      f,
       dim_ic_counterparty  g,
       dim_to_book          h,
       dim_pb_department    i,
       v_ic_invest_cont_m   j,
       v_to_balance_proj_m  k
 where c.l_proj_id = d.l_proj_id
   and c.l_proj_id = b.l_proj_id(+)
   and c.l_dept_id = i.l_dept_id(+)
   and c.l_proj_id = k.l_proj_id(+)
   and c.l_proj_id = a.l_proj_id(+)
   and a.l_fduse_area = e.l_area_id(+)
   and a.l_invindus_id = f.l_indus_id(+)
   and a.l_party_id = g.l_party_id(+)
   and a.l_prod_id = h.l_prod_id(+)
   and a.l_cont_id = j.L_CONT_ID(+)
   and ((nvl(d.c_special_type, '0') <> 'A' and  a.c_busi_type <> '1') or nvl(a.c_cont_type,'99') = '99') --��ȡС���Ҵ���ĺ�ͬ
   --and c.l_setup_date <= 20161231
   and j.L_MONTH_ID = 201612
   and k.l_month_id = 201612
   and c.c_proj_code = 'AVICTC2015X1517'
   and substr(c.l_Effective_Date, 1, 6) <= j.l_month_id
   and substr(c.l_expiration_date, 1, 6) > j.l_month_id;
