--��˾���ָ��Ԥ��ֵ
select a.c_item_code, a.c_item_name, b.*
  from dim_pb_budget_item a, tt_pb_budget_y b
 where a.l_item_id = b.l_item_id
   and b.l_year_id = 2016;

--����
select *
  from (select a.l_month_id,
               c.month_of_year / 3 as ����,
               c.year_id as ���,
               b.c_item_code,
               b.c_item_name,
               lag(a.f_actual, 1, 0) over(partition by b.c_item_code, b.c_item_name order by a.l_month_id),
               a.f_actual
          from tt_pb_budget_m a, dim_pb_budget_item b, dim_month c
         where a.l_item_id = b.l_item_id
           and a.l_month_id = c.month_id
           and b.c_item_code in ('GS000002', 'GS000003', 'GS000004')) t
 where ���� = 4
   and ��� = 2016;
   
--ͬ��
select *
  from (select a.l_month_id,
               c.month_of_year / 3 as ����,
               c.year_id as ���,
               b.c_item_code,
               b.c_item_name,
               lag(a.f_actual, 1, 0) over(partition by b.c_item_code, b.c_item_name order by c.month_of_year, c.year_id),
               a.f_actual
          from tt_pb_budget_m a, dim_pb_budget_item b, dim_month c
         where a.l_item_id = b.l_item_id
           and a.l_month_id = c.month_id
           and b.c_item_code in ('GS000002', 'GS000003', 'GS000004')) t
 where ���� = 4
   and ��� = 2016;