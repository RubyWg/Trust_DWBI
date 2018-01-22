create or replace view v_project_dzy as
select l_proj_id,
       case
         when count(*) > 1 then
          9 --9��ϣ����������Ϸ�Ϊ��ϣ�
         when count(*) = 1 and max(C_GUARAWAY) = 1 then
          1 --1��Ѻ
         when count(*) = 1 and max(C_GUARAWAY) = 2 then
          2 --2��Ѻ
         when count(*) = 1 and max(C_GUARAWAY) = 4 then
          3 --3����
         else
          0 --0�޵���
       end C_GUARAWAY,
        case
         when count(*) > 1 then
         '���'
         when count(*) = 1 and max(C_GUARAWAY) = 1 then
          '��Ѻ'
         when count(*) = 1 and max(C_GUARAWAY) = 2 then
          '��Ѻ'
         when count(*) = 1 and max(C_GUARAWAY) = 4 then
          '����'
         else
          '�޵���'
       end C_GUARAWAYNAME
  from (select distinct d.l_proj_id,
                        case
                          when d.c_coll_cate in ('3', '5') then
                           1 --1��Ѻ
                          when d.c_coll_cate = '2' then
                           2 --2��Ѻ
                          when d.c_coll_cate = '4' then
                           4 --4����
                          else
                           null
                        end C_GUARAWAY
          from dim_ic_collateral d )
 group by l_proj_id;
