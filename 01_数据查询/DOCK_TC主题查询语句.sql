--�����к�ͬ������Ŀ������ģ
select a.*,b.c_invprod_code as ����Ʒ����,
       b.c_busi_scope as ҵ��Χ,
       b.c_busi_scope_n as ҵ��Χ����,
       b.c_proj_type as ��Ŀ����,
       b.c_proj_type_n as ��Ŀ��������,
       b.c_trust_type as ��������,
       b.c_trust_type_n as ������������,
       b.c_func_type as ��������,
       b.c_func_type_n as ������������, 
       b.c_property_type as �Ʋ�Ȩ����,
       b.c_property_type_n as �Ʋ�Ȩ��������,
       b.c_coop_type as ��������,
       b.c_coop_type_n as ������������,
       b.c_invest_indus as Ͷ����ҵ,
       b.c_invest_indus_n as Ͷ����ҵ����,
       b.c_invest_way as Ͷ�ʷ�ʽ,
       b.c_invest_way_n as Ͷ�ʷ�ʽ����,
       b.c_invest_dir as Ͷ�ʷ���,
       b.c_invest_dir_n as Ͷ�ʷ�������
        from (
select r.c_proj_code as ��Ŀ����,
       r.c_proj_name as ��Ŀ����,
       r.d_setup as ��������,
       r.d_expiring as ��������,
       r.c_phase_name,
       r.c_status_name,
       case
         when nvl(r.d_setup, to_date(20000101,'yyyymmdd')) > to_date('20151231','yyyymmdd') then
          '��������'
         else
          '�������'
       end as �������,
       case
         when nvl(r.d_expiring, to_date(20991231,'yyyymmdd')) > to_date('20160531','yyyymmdd') then
          '��ǰ����'
         else
          '�Ѿ�����'
       end as �������,
       sum(t.f_tshares) as ������ģ
  from tta_trust_order t, tde_product s, tde_project r
 where t.c_fundcode = s.c_prod_code
   and s.c_proj_code = r.c_proj_code /*and nvl(r.d_expiring, to_date(20991231,'yyyymmdd')) > to_date('20160531','yyyymmdd')*/
   and t.d_date <= to_date('20160531','yyyymmdd')
 group by r.c_proj_code,r.c_proj_name,r.d_setup,r.d_expiring,r.c_phase_name,
       r.c_status_name
 order by r.c_proj_code) a,tde_project b where a.��Ŀ����=b.c_proj_code;
 

--�й�ģ���޷�������Ʒ
select *
  from (select t.c_prod_code,
               sum(case
                     when t.c_busi_type = '03' then
                      t.f_trade_share * -1
                     else
                      t.f_trade_share
                   end)
          from tta_trust_order t
         where t.c_busi_type in ('50', '02', '03')
         group by t.c_prod_code
        having sum(case
          when t.c_busi_type = '03' then
           t.f_trade_share * -1
          else
           t.f_trade_share
        end)<>0) s
 where not exists
 (select 1 from tde_product b where s.c_prod_code = b.c_prod_code);