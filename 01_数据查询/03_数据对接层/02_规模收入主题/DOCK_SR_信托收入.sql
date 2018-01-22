--��Ŀ��������
select b.c_proj_code  ��Ŀ����,
       b.c_proj_name  ��Ŀ����,
       b.d_setup      ��Ŀ��������,
       �������б���,
       �������вƹ˷�,
       �������б���,
       �������вƹ˷�
  from tde_project b
  left outer join (select a.c_proj_code,
                          sum(case
                                when a.c_revstatus_code = 'EXIST' and
                                     a.c_revtype_code = 'XTBC' then
                                 a.f_revenue
                                else
                                 0
                              end) as �������б���,
                          sum(case
                                when a.c_revstatus_code = 'EXIST' and
                                     a.c_revtype_code = 'XTCGF' then
                                 a.f_revenue
                                else
                                 0
                              end) as �������вƹ˷�,
                          sum(case
                                when a.c_revstatus_code = 'NEW' and
                                     a.c_revtype_code = 'XTBC' then
                                 a.f_revenue
                                else
                                 0
                              end) as �������б���,
                          sum(case
                                when a.c_revstatus_code = 'NEW' and
                                     a.c_revtype_code = 'XTCGF' then
                                 a.f_revenue
                                else
                                 0
                              end) as �������вƹ˷�
                     from tde_revenue_change a
                    where a.d_revenue >= to_date('20160101', 'yyyymmdd')
                      and a.d_revenue <= to_date('20160930', 'yyyymmdd')
                    group by a.c_proj_code) t
    on t.c_proj_code = b.c_proj_code
 order by b.d_setup;