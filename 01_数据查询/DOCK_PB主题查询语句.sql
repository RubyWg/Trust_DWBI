

--�������Ƽ�д����
select tt.c_area_code as c_area_code,
       substr(tt.c_area_name, l_begin+1, l_end) as c_area_name
  from (select t.c_area_code,
               t.c_area_name,
               case when instr(t.c_area_name, 'ʡ') = 0 and instr(t.c_area_name,'���ɹ�')>0 then 3
                    when  instr(t.c_area_name, 'ʡ') = 0 and instr(t.c_area_name,'����')>0 then 2
                    when  instr(t.c_area_name, 'ʡ') = 0 and instr(t.c_area_name,'����')>0 then 2
                    when  instr(t.c_area_name, 'ʡ') = 0 and instr(t.c_area_name,'�½�')>0 then 2
                    else  instr(t.c_area_name, 'ʡ') end as l_begin,
               instr(t.c_area_name, '��') as l_end
          from tde_area t
         where t.l_area_level = 2) tt;
   and t.c_area_name like '%����%';