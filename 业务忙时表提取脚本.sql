
--�ĸ��̶�æʱ 12 , 13, 22, 23ʱ
with busyhour AS (
    SELECT 
        lcellt.lncel_id AS lncel_id,
        to_char(lcellt.period_start_time, 'yyyymmddhh24') AS pm_date_hour
    FROM
        NOKLTE_PS_LCELLT_LNCEL_HOUR lcellt
    WHERE
            lcellt.period_start_time >= to_date(&start_datetime,'yyyymmdd')
        AND lcellt.period_start_time <  to_date(&end_datetime,'yyyymmdd')
        AND to_char(lcellt.period_start_time,'hh24') in  ('12','13','22','23')
    ORDER BY 
    lcellt.lncel_id
    )








--ȡÿ��ҵ��������һ��Сʱ
with busyhour AS (
    SELECT 
        m1.lncel_id,
        mm.pm_date AS pm_date_hour
    FROM
        (select 
            lncel_id,
            to_char(to_date(pm_date,'yyyymmddhh24'), 'yyyymmdd') as pm_date,

            max(���ҵ����) AS ���ҵ����
        from    
                (SELECT 
            lcellt.lncel_id AS lncel_id,
            to_char(lcellt.period_start_time, 'yyyymmddhh24') pm_date,
            SUM(PDCP_SDU_VOL_UL + PDCP_SDU_VOL_DL)  AS ���ҵ����
            
        FROM 
            NOKLTE_PS_LCELLT_LNCEL_HOUR lcellt
        WHERE 
                lcellt.period_start_time >= to_date(&start_datetime, 'yyyymmdd')
            AND lcellt.period_start_time < to_date(&end_datetime, 'yyyymmdd')


        GROUP BY 
            lcellt.lncel_id,
            to_char(lcellt.period_start_time, 'yyyymmddhh24')
            )
        group by 
            lncel_id,
            to_char(to_date(pm_date,'yyyymmddhh24'), 'yyyymmdd')
        ) m1
        
    left JOIN 
            
        (SELECT 
            lcellt.lncel_id AS lncel_id,
            to_char(lcellt.period_start_time, 'yyyymmddhh24') pm_date,
            SUM(PDCP_SDU_VOL_UL + PDCP_SDU_VOL_DL)  AS ���ҵ����
            
        FROM 
            NOKLTE_PS_LCELLT_LNCEL_HOUR lcellt
        WHERE 
                lcellt.period_start_time >= to_date(&start_datetime, 'yyyymmdd')
            AND lcellt.period_start_time < to_date(&end_datetime, 'yyyymmdd')


        GROUP BY 
            lcellt.lncel_id,
            to_char(lcellt.period_start_time, 'yyyymmddhh24')
        )   mm ON m1.lncel_id = mm.lncel_id  AND m1.���ҵ���� = mm.���ҵ���� AND mm.���ҵ����<>0
    
    )

    