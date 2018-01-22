create or replace view v_indicator as
select t.l_month_id, (case when a.c_item_name like '%Ӫҵ����%' then 1
                           when a.c_item_name like '%�����ܶ�%' then 2 else 6 end) as l_order,
                     (case when a.c_item_name like '%Ӫҵ����%' then 'Ӫҵ����'
                           when a.c_item_name like '%�����ܶ�%' then '�����ܶ�' else '�������' end) as c_name, t.f_money_eot
  from tt_fi_statement_m t, dim_fi_statement_item a, dim_fi_statement b
 where t.l_item_id = a.l_item_id and a.l_state_id = b.l_state_id
   and ( a.c_item_name like '%Ӫҵ����%' or a.c_item_name like '%�����ܶ�%' or a.c_item_name like '%ҵ�񼰹����%' )
 union all
select a.month_id as l_month_id, 3 as l_order, '��������ֵ' as c_name,
       t.f_actual as f_value
  from tt_pb_budget_y t, dim_month a, dim_pb_budget_item b
 where t.l_year_id = a.year_id and t.l_item_id = b.l_item_id
   and a.month_of_year = 12
   and b.c_item_code = 'GS000016'
 union all
select t.l_month_id, 4 as l_order, 'ROE' as c_name, ( case when sum(case when a.c_item_name like '%������Ȩ��ϼ�%' then (t.f_money_eot + t.f_money_bot) / 2 else 0 end) <> 0 then
       sum(case when a.c_item_name like '%������%' then t.f_money_eot else 0 end) /
       sum(case when a.c_item_name like '%������Ȩ��ϼ�%' then (t.f_money_eot + t.f_money_bot) / 2 else 0 end) else null end) as f_value
  from tt_fi_statement_m t, dim_fi_statement_item a, dim_fi_statement b
 where t.l_item_id = a.l_item_id and a.l_state_id = b.l_state_id
 group by t.l_month_id
 union all
select t.l_month_id, 7 as l_order, 'ROA' as c_name, ( case when sum(case when a.c_item_name like '%�ʲ��ϼ�%' then (t.f_money_eot + t.f_money_bot) / 2 else 0 end) <> 0 then
       sum(case when a.c_item_name like '%�����ܶ�%' then t.f_money_eot else 0 end) /
       sum(case when a.c_item_name like '%�ʲ��ϼ�%' then (t.f_money_eot + t.f_money_bot) / 2 else 0 end) else null end) as f_value
  from tt_fi_statement_m t, dim_fi_statement_item a, dim_fi_statement b
 where t.l_item_id = a.l_item_id and a.l_state_id = b.l_state_id
 group by t.l_month_id
 union all
select t.l_month_id, 5 as l_order, '�ɱ�������' as c_name, ( case when sum(case when a.c_item_code in ('020123','020122','020112') then t.f_money_eot else 0 end) <> 0 then
       sum(case when a.c_item_code in ('020125','020126','020112') then t.f_money_eot else 0 end) else null end) /
       sum(case when a.c_item_code in ('020113','020108') then t.f_money_eot else 0 end)
        as f_value
  from tt_fi_statement_m t, dim_fi_statement_item a, dim_fi_statement b
 where t.l_item_id = a.l_item_id and a.l_state_id = b.l_state_id
 group by t.l_month_id;
