
--四个固定忙时 12 , 13, 22, 23时
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

select 
    &start_datetime||'_'||&end_datetime,
    --TTime,
    区域,
    Round(Decode(AVG(M8009C6 + M8014C6 + M8014C14),0, 0, 100 * AVG(M8009C7 + M8014C7 + M8014C19) / AVG(M8009C6 + M8014C6 + M8014C14)),2) LTE系统内切换成功率,
    AVG(M8009C6) eNB内切换请求次数,
    AVG(M8009C7) eNB内切换成功次数,
    Round(decode(AVG(M8009C6), 0, 0, 100 * AVG(M8009C7) / AVG(M8009C6)),2) eNB内切换成功率,
    AVG(M8014C6) X2切换出请求次数,
    AVG(M8014C7) X2切换出成功次数,
    AVG(M8014C3+M8014C16) as ENB间切出无线,
    AVG(M8014C5+M8014C17) as ENB间切出传输,       
    Round(decode(AVG(M8014C6), 0, 0, 100 * AVG(M8014C7) / AVG(M8014C6)),2) X2切换成功率,
    AVG(M8014C14) as S1切换出请求次数,
    AVG(M8014C18) as eNB间S1出准备成功,
    AVG(M8014C19) as S1切换出成功次数,
    Round(decode(AVG(M8014C14),0,0,100 * AVG(M8014C19) / AVG(M8014C14)),2) S1切换成功率,
    AVG(M8021C0) as 异频切换出执行,
    AVG(M8021C2) as 异频切换出成功次数,             
    Round(decode(AVG(M8021C0), 0, 0, 100 * AVG(M8021C2) / AVG(M8021C0)),2) as 异频切换成功率, 
    AVG(M8014C6+M8014C18+M8009C6-M8021C0) as 同频切换出执行,      
    AVG(M8014C7+M8014C19+M8009C7-M8021C2) as 同频切换出成功次数,     
    Round(decode(AVG(M8014C6+M8014C18+M8009C6-M8021C0), 0, 0, 100 * AVG(M8014C7+M8014C19+M8009C7-M8021C2) /  AVG(M8014C6+M8014C18+M8009C6-M8021C0)),2) as 同频切换成功率,             
    AVG(M8016C14) LTE至WCDMA切换请求次数,
    AVG(M8016C23) LTE至WCDMA切换成功次数,
    Round(decode(AVG(M8016C14), 0, 0, 100 * AVG(M8016C23) / AVG(M8016C14)), 2) LTE至WCDMA切换成功率,
    AVG(M8016C11) LTE_CSFB_REDIR请求次数,
    AVG(重定向请求次数_NoCSFB) as "重定向请求次数_NoCSFB",
    AVG(E_RAB正常释放次数) as "E_RAB正常释放次数",
    ROUND(DECODE(AVG(E_RAB正常释放次数),0,0,AVG(重定向请求次数_NoCSFB)/AVG(E_RAB正常释放次数))*100,2) as "重定向比例",
    AVG(M8006C1) as ERAB建立成功个数,
    Round(decode(AVG(M8006C1), 0, 0, 100 * AVG(M8006C258-M8016C11) / AVG(M8006C1)),2) as "倒流比",                       
    Round(decode(AVG(M8014C6+M8014C18), 0, 0, 100 * AVG(M8014C6) / AVG(M8014C6+M8014C18)),2) as X2切换占比S1出准备,             
    Round(decode(AVG(M8014C6+M8014C14), 0, 0, 100 * AVG(M8014C6) / AVG(M8014C6+M8014C14)),2) as X2切换占比S1出请求   



from 
    (SELECT 
           sdatetime,
           TTime,
           kkkk.区域,
           kkkk.bts_version,
           --enb_id,
           --enb_cell,
           --enb_id || (SUBSTR(enb_cell, -2)) as CELLID,
           sum(m8001C199) AS m8001C199,
           sum(M8001C153) AS M8001C153,
           sum(M8001C154) AS M8001C154,
           sum(M8001C200) AS M8001C200,
           sum(M8001C223) AS M8001C223,
           sum(M8001C254) AS M8001C254,
           sum(M8001C259) AS M8001C259,
           sum(M8006C0) AS M8006C0,
           sum(M8006C3) AS M8006C3,
           sum(M8006C5) AS M8006C5,
           sum(M8006C16) AS M8006C16,
           sum(M8006C1) AS M8006C1,
           sum(M8006C6) AS M8006C6,
           sum(M8006C7) AS M8006C7,
           sum(M8006C8) AS M8006C8,
           sum(M8006C9) AS M8006C9,
           sum(M8006C10) AS M8006C10,
           sum(M8006C12) AS M8006C12,
           sum(M8006C13) AS M8006C13,
           sum(M8006C14) AS M8006C14,
           sum(M8006C15) AS M8006C15,
           sum(M8006C17) AS M8006C17,
           sum(M8006C18) AS M8006C18,
           sum(M8006C26) AS M8006C26,
           sum(M8006C35) AS M8006C35,
           sum(M8006C36) AS M8006C36,
           sum(M8006C44) AS M8006C44,
           sum(M8006C89) AS M8006C89,
           sum(M8006C98) AS M8006C98,
           sum(M8006C107) AS M8006C107,
           sum(M8006C116) AS M8006C116,
           sum(M8006C125) AS M8006C125,
           sum(M8006C134) AS M8006C134,
           sum(M8006C143) AS M8006C143,
           sum(M8006C152) AS M8006C152,
           sum(M8006C161) AS M8006C161,
           sum(M8006C162) AS M8006C162,
           sum(M8006C163) AS M8006C163,
           sum(M8006C164) AS M8006C164,
           sum(M8006C165) AS M8006C165,
           sum(M8006C166) AS M8006C166,
           sum(M8006C167) AS M8006C167,
           sum(M8006C168) AS M8006C168,
           sum(M8006C169) AS M8006C169,
           sum(M8006C170) AS M8006C170,
           sum(M8006C171) AS M8006C171,
           sum(M8006C172) AS M8006C172,
           sum(M8006C173) AS M8006C173,
           sum(M8006C176) AS M8006C176,
           sum(M8006C177) AS M8006C177,
           sum(M8006C178) AS M8006C178,
           sum(M8006C179) AS M8006C179,
           sum(M8006C180) AS M8006C180,
           sum(M8006C255) AS M8006C255,
           sum(M8006C258) AS M8006C258,
           sum(M8006C260) AS M8006C260,
           sum(M8008C0) AS M8008C0,
           sum(m8008c1) AS m8008c1,
           sum(m8008c2) AS m8008c2,
           sum(M8008C4) AS M8008C4,
           sum(M8008C5) AS M8008C5,
           sum(M8009C2) AS M8009C2,
           sum(M8009C6) AS M8009C6,
           sum(M8009C7) AS M8009C7,
           sum(M8011C50) AS M8011C50,
           sum(M8011C54) AS M8011C54,
           sum(M8012C19) AS M8012C19,
           sum(M8012C20) AS M8012C20,
           sum(M8013C5) AS M8013C5,
           sum(M8013C9) AS M8013C9,
           sum(M8013C10) AS M8013C10,
           sum(M8013C11) AS M8013C11,
           sum(M8013C12) AS M8013C12,
           sum(M8013C13) AS M8013C13,
           sum(M8013C15) AS M8013C15,
           sum(M8013C16) AS M8013C16,
           sum(M8013C17) AS M8013C17,
           sum(M8013C18) AS M8013C18,
           sum(M8013C19) AS M8013C19,
           sum(M8013C20) AS M8013C20,
           sum(M8013C21) AS M8013C21,
           sum(M8014C0) AS M8014C0,
           sum(M8014C6) AS M8014C6,
           sum(M8014C7) AS M8014C7,
           sum(M8014C8) AS M8014C8,
           sum(M8014C3) AS M8014C3,
           sum(M8014C5) AS M8014C5,
           sum(M8014C16) AS M8014C16,
           sum(M8014C17) AS M8014C17,
           sum(M8014C14) AS M8014C14,
           sum(M8014C18) AS M8014C18,
           sum(M8014C19) AS M8014C19,
           sum(M8014C20) AS M8014C20,
           sum(M8015C2) AS M8015C2,
           sum(M8015C9) AS M8015C9,
           sum(M8015C8) AS M8015C8,
           sum(M8015C5) AS M8015C5,
           sum(M8015C6) AS M8015C6,
           sum(M8015C7) AS M8015C7,
           sum(M8016C11) AS M8016C11,
           sum(M8016C14) AS M8016C14,
           sum(M8016C21) AS M8016C21,
           sum(M8016C23) AS M8016C23,
           sum(M8016C25) AS M8016C25,
           sum(M8016C26) AS M8016C26,
           sum(M8016C27) AS M8016C27,
           sum(M8016C29) AS M8016C29,
           sum(M8016C30) AS M8016C30,
           sum(M8021C0) AS M8021C0,
           sum(M8021C2) AS M8021C2,
           sum(M8020C3) AS M8020C3,
           sum(M8020C6) AS M8020C6,
           sum(M8020C4) AS M8020C4,
           decode((CASE WHEN kkkk.bts_version='FL16' THEN 'FL16' WHEN kkkk.bts_version='FLF16' THEN 'FL16' WHEN kkkk.bts_version='FL16A' THEN 'FL16' WHEN kkkk.bts_version='TL16' THEN 'FL16' ELSE kkkk.bts_version END),'FL16',sum(M8006C258-M8016C11),sum(M8006C15 - M8016C11)) as 重定向请求次数_NoCSFB,
           decode((CASE WHEN kkkk.bts_version='FL16' THEN 'FL16' WHEN kkkk.bts_version='FLF16' THEN 'FL16' WHEN kkkk.bts_version='FL16A' THEN 'FL16' WHEN kkkk.bts_version='TL16' THEN 'FL16' ELSE kkkk.bts_version END),'FL16',sum(M8006C255+M8006C258+M8006C6+M8006C7+M8006C260),sum(M8006C10 + M8006C15 + M8006C6 + M8006C7 + M8006C180)) as "E_RAB正常释放次数"            
                        
      FROM (SELECT M8013.sdatetime ,M8013.TTime,
                   enb_id || '_' || cell_id enb_cell,
                   M8013.区域,
                   enb_id,
                   cell_id,
                --   bts_ip,
                   bts_version,
                   bts_name,
                   cel_name,
                   m8001C199 AS m8001C199,
                   M8001C153 AS M8001C153,
                   M8001C154 AS M8001C154,
                   M8001C200 AS M8001C200,
                   M8001C223 AS M8001C223,
                   M8001C254 AS M8001C254,
                   M8001C259 AS M8001C259,
                   M8006C0 AS M8006C0,
                   M8006C3 AS M8006C3,
                   M8006C5 AS M8006C5,
                   M8006C16 AS M8006C16,
                   M8006C1 AS M8006C1,
                   M8006C6 AS M8006C6,
                   M8006C7 AS M8006C7,
                   M8006C8 AS M8006C8,
                   M8006C9 AS M8006C9,
                   M8006C10 AS M8006C10,
                   M8006C12 AS M8006C12,
                   M8006C13 AS M8006C13,
                   M8006C14 AS M8006C14,
                   M8006C15 AS M8006C15,
                   M8006C17 AS M8006C17,
                   M8006C18 AS M8006C18,
                   M8006C26 AS M8006C26,
                   M8006C35 AS M8006C35,
                   M8006C36 AS M8006C36,
                   M8006C44 AS M8006C44,
                   M8006C89 AS M8006C89,
                   M8006C98 AS M8006C98,
                   M8006C107 AS M8006C107,
                   M8006C116 AS M8006C116,
                   M8006C125 AS M8006C125,
                   M8006C134 AS M8006C134,
                   M8006C143 AS M8006C143,
                   M8006C152 AS M8006C152,
                   M8006C161 AS M8006C161,
                   M8006C162 AS M8006C162,
                   M8006C163 AS M8006C163,
                   M8006C164 AS M8006C164,
                   M8006C165 AS M8006C165,
                   M8006C166 AS M8006C166,
                   M8006C167 AS M8006C167,
                   M8006C168 AS M8006C168,
                   M8006C169 AS M8006C169,
                   M8006C170 AS M8006C170,
                   M8006C171 AS M8006C171,
                   M8006C172 AS M8006C172,
                   M8006C173 AS M8006C173,
                   M8006C176 AS M8006C176,
                   M8006C177 AS M8006C177,
                   M8006C178 AS M8006C178,
                   M8006C179 AS M8006C179,
                   M8006C180 AS M8006C180,
                   M8006C255 AS M8006C255,
                   M8006C258 AS M8006C258,
                   M8006C260 AS M8006C260,
                   M8008C0 AS M8008C0,
                   m8008c1 AS m8008c1,
                   m8008c2 AS m8008c2,
                   M8008C4 AS M8008C4,
                   M8008C5 AS M8008C5,
                   M8009C2 AS M8009C2,
                   M8009C6 AS M8009C6,
                   M8009C7 AS M8009C7,
                   M8011C50 AS M8011C50,
                   M8011C54 AS M8011C54,
                   M8012C19 AS M8012C19,
                   M8012C20 AS M8012C20,
                   M8013C5 AS M8013C5,
                   M8013C9 AS M8013C9,
                   M8013C10 AS M8013C10,
                   M8013C11 AS M8013C11,
                   M8013C12 AS M8013C12,
                   M8013C13 AS M8013C13,
                   M8013C15 AS M8013C15,
                   M8013C16 AS M8013C16,
                   M8013C17 AS M8013C17,
                   M8013C18 AS M8013C18,
                   M8013C19 AS M8013C19,
                   M8013C20 AS M8013C20,
                   M8013C21 AS M8013C21,
                   M8014C0 AS M8014C0,
                   M8014C6 AS M8014C6,
                   M8014C7 AS M8014C7,
                   M8014C8 AS M8014C8,
                   M8014C3 AS M8014C3,
                   M8014C5 AS M8014C5,
                   M8014C16 AS M8014C16,
                   M8014C17 AS M8014C17,
                   M8014C14 AS M8014C14,
                   M8014C18 AS M8014C18,
                   M8014C19 AS M8014C19,
                   M8014C20 AS M8014C20,
                   M8015C2 AS M8015C2,
                   M8015C9 AS M8015C9,
                   M8015C8 AS M8015C8,
                   M8015C5 AS M8015C5,
                   M8015C6 AS M8015C6,
                   M8015C7 AS M8015C7,
                   M8016C11 AS M8016C11,
                   M8016C14 AS M8016C14,
                   M8016C21 AS M8016C21,
                   M8016C23 AS M8016C23,
                   M8016C25 AS M8016C25,
                   M8016C26 AS M8016C26,
                   M8016C27 AS M8016C27,
                   M8016C29 AS M8016C29,
                   M8016C30 AS M8016C30,
                   M8021C0 AS M8021C0,
                   M8021C2 AS M8021C2,
                   M8020C3 AS M8020C3,
                   M8020C6 AS M8020C6,
                   M8020C4 AS M8020C4
              FROM (select to_char(period_start_time, 'yyyymmdd') sdatetime,
               to_char(period_start_time, 'hh24') TTime,
                            PMRAW.lncel_id,
                            to_char(period_start_time, 'yyyymmdd')|| to_char(period_start_time, 'hh24') || PMRAW.lncel_id cel_key_id,
                            sum(PDCP_SDU_UL) M8001C153,
                            sum(PDCP_SDU_DL) M8001C154,
                            avg(nvl(RRC_CONN_UE_AVG, 0)) M8001C199 --The average number of UEs in RRC_CONNECTED state over the measurement period. The average value is the arithmetical average of samples taken from the number of UEs in RRC_CONNECTED state.
                           ,
                            max(nvl(RRC_CONN_UE_MAX, 0)) M8001C200 --The highest value for number of UEs in RRC_CONNECTED state over the measurement period.
                           ,
                            avg(nvl(CELL_LOAD_ACT_UE_AVG, 0)) M8001C223 --The average number of active UE per cell during measurement period. A UE is termed active if at least a single non-GBR DRB has been successfully configured for it.
                           ,
                            sum(PDCP_SDU_LOSS_UL) M8001C254 ---Number of missing UL PDCP packets of a data bearer that are not delivered to higher layers.
                           ,
                            sum(PDCP_SDU_LOSS_DL) M8001C259 ---Number of DL PDCP SDUs that could not be successfully transmitted.
                     
                       FROM 
                            NOKLTE_PS_LCELLD_lncel_hour PMRAW
                            INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                      where
                      period_start_time >= to_date(&start_datetime, 'yyyymmdd')
                   and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                      group by to_char(period_start_time, 'yyyymmdd'),
                       to_char(period_start_time, 'hh24'),
                               PMRAW.lncel_id,
                               to_char(period_start_time, 'yyyymmdd') ||  to_char(period_start_time, 'hh24') || PMRAW.lncel_id) M8001,
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime,
                    to_char(period_start_time, 'hh24') TTime,
                            PMRAW.lncel_id,
                            to_char(period_start_time, 'yyyymmdd') ||  to_char(period_start_time, 'hh24') || PMRAW.lncel_id cel_key_id,
                            sum(nvl(EPS_BEARER_SETUP_ATTEMPTS, 0)) M8006C0 --The number of EPS bearer setup attempts. Each bearer of the E-RAB to Be Setup List IE is counted.
                           ,
                            sum(nvl(EPS_BEARER_SETUP_COMPLETIONS, 0)) M8006C1 --The number of EPS bearer setup completions. Each bearer of the E-RAB Setup List IE is counted.
                           ,
                            sum(nvl(EPS_BEARER_SETUP_FAIL_RNL, 0)) M8006C2 --The number of EPS bearer setup failures due to Radio Network Layer. Each bearer of the E-RAB Failed to Setup List IE is counted.
                           ,
                            sum(nvl(EPS_BEARER_SETUP_FAIL_TRPORT, 0)) M8006C3 --The number of EPS bearer setup failures due to Transport Layer. Each bearer of the E-RAB Failed to Setup List IE is counted.
                           ,
                            sum(nvl(EPS_BEARER_SETUP_FAIL_RESOUR, 0)) M8006C4 --The number of EPS bearer setup failures due to Resource reasons. Each bearer of the E-RAB Failed to Setup List IE has to be counted.
                           ,
                            sum(nvl(EPS_BEARER_SETUP_FAIL_OTH, 0)) M8006C5 --The number of EPS bearer setup failures due to Other reasons. Each bearer of the E-RAB Failed to Setup List IE is counted.
                           ,
                            sum(nvl(EPC_EPS_BEARER_REL_REQ_NORM, 0)) M8006C6 --The number of released Data Radio Bearers due to normal release per call. Each bearer of the E-RAB To Be Released List IE has to be counted. In case of a UE context release request, all established EPS Bearers are counted.
                           ,
                            sum(nvl(EPC_EPS_BEARER_REL_REQ_DETACH, 0)) M8006C7 --The number of EPC-initiated EPS Bearer Release requests due to the Detach procedure by the UE or MME (NAS cause). Each bearer of the E-RAB To Be Released List IE has to be counted. In case of a UE context release request, all established EPS Bearers are counted.
                           ,
                            sum(nvl(EPC_EPS_BEARER_REL_REQ_RNL, 0)) M8006C8 --The number of EPC-initiated EPS Bearer Release requests due to the Radio Network Layer cause. Each bearer of the E-RAB to be Released List IE is counted.
                           ,
                            sum(nvl(EPC_EPS_BEARER_REL_REQ_OTH, 0)) M8006C9 --The number of released Data-Radio Bearers due to Other Reasons. Each bearer of the E-RAB To Be Released List IE has to be counted. In case of a UE context release request, all established EPS Bearer are counted.
                           ,
                            sum(nvl(ENB_EPS_BEARER_REL_REQ_NORM, 0)) M8006C10 --The number of eNB-initiated EPS Bearer Release requests due to the UE inactivity. In case of the UE context release request, all the established EPS Bearers are counted.
                           ,
                            sum(nvl(ENB_EPS_BEARER_REL_REQ_RNL, 0)) M8006C12 --The number of E-RABs requested to be released in case a Radio Link Failure is detected by eNB.
                           ,
                            sum(nvl(ENB_EPS_BEARER_REL_REQ_OTH, 0)) M8006C13 --The number of eNB-initiated EPS Bearer Release requests due to Other causes . In case of a UE context release request, all the established EPS Bearers are counted.
                           ,
                            sum(nvl(ENB_EPS_BEARER_REL_REQ_TNL, 0)) M8006C14 --The number of eNB-initiated EPS Bearer Release requests due to Transport Layer Cause
                           ,
                            sum(nvl(ENB_EPSBEAR_REL_REQ_RNL_REDIR, 0)) M8006C15 --The number of eNB-initiated EPS Bearer Release requests due Redirect (release due to RNL E-UTRAN generated reason or RNL Inter-RAT Redirection).
                           ,
                            sum(nvl(EPS_BEARER_SETUP_FAIL_HO, 0)) M8006C16 --The number of EPS bearer setup failures due to Handover Pending reason. Each bearer of the E-RAB Failed to Setup List IE is counted.
                           ,
                            sum(nvl(EPS_BEARER_STP_ATT_INI_QCI_1, 0)) M8006C17 --The number of initial EPS bearer setup attempts per QCI1. Each bearer of the E-RAB to Be Setup List IE is counted.
                           ,
                            sum(nvl(EPS_BEAR_STP_ATT_INI_NON_GBR, 0)) M8006C18 --The number of initial EPS bearer setup attempts per non-GBR. Each bearer of the E-RAB to Be Setup List IE is counted.
                           ,
                            sum(nvl(EPS_BEARER_STP_ATT_ADD_QCI_1, 0)) M8006C26 --The number of additional EPS bearer setup attempts per QCI1. Each bearer of the E-RAB to Be Setup List IE is counted.
                           ,
                            sum(nvl(EPS_BEARER_STP_COM_INI_QCI1, 0)) M8006C35 --The number of initial EPS bearer setup completions per QCI1. Each bearer of the E-RAB Setup List IE is counted.
                           ,
                            sum(nvl(EPS_BEAR_STP_COM_INI_NON_GBR, 0)) M8006C36 --The number of initial EPS bearer setup completions per non-GBR. Each bearer of the E-RAB Setup List IE is counted.
                           ,
                            sum(nvl(EPS_BEAR_SET_COM_ADDIT_QCI1, 0)) M8006C44 --The number of additional EPS bearer setup completions for QCI1. Each bearer of the E-RAB Setup List IE is counted.
                           ,
                            sum(nvl(EPC_EPS_BEAR_REL_REQ_N_QCI1, 0)) M8006C89 --The number of EPC-initiated EPS Bearer Release requests for QCI1 due to normal release by UE. Each bearer of the E-RAB to be Released List IE is counted.
                           ,
                            sum(nvl(EPC_EPS_BEAR_REL_REQ_D_QCI1, 0)) M8006C98 --The number of EPC-initiated EPS Bearer Release requests for QCI1 due to the Detach procedure by the UE or the MME. Each bearer of the E-RAB to be Released List IE is counted.
                           ,
                            sum(nvl(EPC_EPS_BEAR_REL_REQ_R_QCI1, 0)) M8006C107 --The number of EPC-initiated EPS Bearer Release requests for QCI1 due to the Radio Network Layer cause. Each bearer of the E-RAB to be Released List IE is counted.
                           ,
                            sum(nvl(EPC_EPS_BEAR_REL_REQ_O_QCI1, 0)) M8006C116 --The number of EPC-initiated EPS Bearer Release requests for QCI1 due to Other causes. Each bearer of the E-RAB to be Released List IE is counted.
                           ,
                            sum(nvl(ENB_EPS_BEAR_REL_REQ_N_QCI1, 0)) M8006C125 --The number of eNB-initiated EPS Bearer Release requests for QCI1 due to the Normal release. In case of a UE context release request, all the established EPS Bearers are counted.
                           ,
                            sum(nvl(ENB_EPS_BEAR_REL_REQ_R_QCI1, 0)) M8006C134 --The number of eNB-initiated EPS Bearer Release requests for QCI1 due to Radio Network Layer cause. In case of a UE context release request, all the established EPS Bearers are counted.
                           ,
                            sum(nvl(ENB_EPS_BEAR_REL_REQ_O_QCI1, 0)) M8006C143 --The number of eNB-initiated EPS Bearer Release requests for QCI1 due to Other causes . In case of a UE context release request, all the established EPS Bearers are counted.
                           ,
                            sum(nvl(ENB_EPS_BEAR_REL_REQ_T_QCI1, 0)) M8006C152 --The number of eNB-initiated EPS Bearer Release requests for QCI1 due Transport Layer Cause - Transport Resource UnavailableCause.
                           ,
                            sum(nvl(ENB_EPS_BEAR_REL_REQ_RD_QCI1, 0)) M8006C161 --The number of eNB-initiated EPS Bearer Release requests for QCI1 due Redirect (release due to RNL E-UTRAN generated reason or RNL Inter-RAT Redirection )
                           ,
                            sum(nvl(EPS_BEARER_STP_ATT_INI_QCI_2, 0)) M8006C162 --This measurement provides the number of initial EPS bearer setup attempts for GBR DRBs of QCI2 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_ATT_INI_QCI_3, 0)) M8006C163 --This measurement provides the number of initial EPS bearer setup attempts for GBR DRBs of QCI3 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_ATT_INI_QCI_4, 0)) M8006C164 --This measurement provides the number of initial EPS bearer setup attempts for GBR DRBs of QCI4 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_ATT_ADD_QCI_2, 0)) M8006C165 --This measurement provides the number of additional EPS bearer setup attempts for GBR DRBs of QCI2 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_ATT_ADD_QCI_3, 0)) M8006C166 --This measurement provides the number of additional EPS bearer setup attempts for GBR DRBs of QCI3 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_ATT_ADD_QCI_4, 0)) M8006C167 --This measurement provides the number of additional EPS bearer setup attempts for GBR DRBs of QCI4 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_COM_INI_QCI_2, 0)) M8006C168 --This measurement provides the number of initial EPS bearer setup completions for GBR DRBs of QCI2 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_COM_INI_QCI_3, 0)) M8006C169 --This measurement provides the number of initial EPS bearer setup completions for GBR DRBs of QCI3 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_COM_INI_QCI_4, 0)) M8006C170 --This measurement provides the number of initial EPS bearer setup completions for GBR DRBs of QCI4 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_COM_ADD_QCI_2, 0)) M8006C171 --This measurement provides the number of additional EPS bearer setup completions for GBR DRBs of QCI2 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_COM_ADD_QCI_3, 0)) M8006C172 --This measurement provides the number of additional EPS bearer setup completions for GBR DRBs of QCI3 characteristics.
                           ,
                            sum(nvl(EPS_BEARER_STP_COM_ADD_QCI_4, 0)) M8006C173 --This measurement provides the number of additional EPS bearer setup completions for GBR DRBs of QCI4 characteristics.
                           ,
                            sum(nvl(PRE_EMPT_GBR_BEARER, 0)) M8006C174 --This measurement provides the number of GBR E-RABs&#10;(Guaranteed Bit Rate bearers, 3GPP TS 23.203) being released due to lack of radio resources.
                           ,
                            sum(nvl(PRE_EMPT_NON_GBR_BEARER, 0)) M8006C175 --This measurement provides the number of non-GBR E-RABs&#10;(non-Guaranteed Bit Rate bearers, 3GPP TS 23.203) being released due to lack of radio resources.
                           ,
                            sum(nvl(ERAB_REL_ENB_ACT_QCI1, 0)) M8006C176 --This measurement provides the number of released active E-RABs (i.e. when there was user data in the queue at the time of release) with QCI1 characteristics. The release is initiated by the eNB due to radio connectivity problems.
                           ,
                            sum(nvl(ERAB_REL_ENB_ACT_QCI2, 0)) M8006C177 --This measurement provides the number of released active E-RABs (i.e. when there was user data in the queue at the time of release) with QCI2 characteristics. The release is initiated by the eNB due to radio connectivity problems.
                           ,
                            sum(nvl(ERAB_REL_ENB_ACT_QCI3, 0)) M8006C178 --This measurement provides the number of released active E-RABs (i.e. when there was user data in the queue at the time of release) with QCI3 characteristics. The release is initiated by the eNB due to radio connectivity problems.
                           ,
                            sum(nvl(ERAB_REL_ENB_ACT_QCI4, 0)) M8006C179 --This measurement provides the number of released active E-RABs (i.e. when there was user data in the queue at the time of release) with QCI4 characteristics. The release is initiated by the eNB due to radio connectivity problems.
                           ,
                            sum(nvl(ERAB_REL_ENB_ACT_NON_GBR, 0)) M8006C180 --This measurement provides the number of released active E-RABs (i.e. when there was user data in the queue at the time of release) with non-GBR characteristics (QCI5..9). The release is initiated by the eNB due to radio connectivity problems.
                           ,
                            sum(nvl(ERAB_IN_SESSION_TIME_QCI1, 0)) M8006C181 --This measurement provides the aggregated in-session activity time in seconds for all E-RABs with QCI1 characteristics. The E-RAB is said to be in session if any user data has been transferred in UL or DL direction within the last 100msec.
                           ,
                            sum(nvl(ERAB_IN_SESSION_TIME_QCI2, 0)) M8006C182 --This measurement provides the aggregated in-session activity time in seconds for all E-RABs with QCI2 characteristics. The E-RAB is said to be in session if any user data has been transferred in UL or DL direction within the last 100msec.
                           ,
                            sum(nvl(ERAB_IN_SESSION_TIME_QCI3, 0)) M8006C183 --This measurement provides the aggregated in-session activity time in seconds for all E-RABs with QCI3 characteristics. The E-RAB is said to be in session if any user data has been transferred in UL or DL direction within the last 100msec.
                           ,
                            sum(nvl(ERAB_IN_SESSION_TIME_QCI4, 0)) M8006C184 --This measurement provides the aggregated in-session activity time in seconds for all E-RABs with QCI4 characteristics. The E-RAB is said to be in session if any user data has been transferred in UL or DL direction within the last 100msec.
                           ,
                           sum(nvl(ERAB_REL_ENB_RNL_INA, 0)) M8006C255
                           ,
                           sum(nvl(ERAB_REL_ENB_RNL_RED, 0)) M8006C258
                           ,
                           sum(nvl(ERAB_REL_ENB_RNL_RRNA, 0)) M8006C260
                           ,
                            sum(nvl(ERAB_IN_SESSION_TIME_NON_GBR, 0)) M8006C185 --This measurement provides the aggregated in-session activity time in seconds for all E-RABs with non-GBR (QCI5..9) characteristics. The E-RAB is said to be in session if any user data has been transferred in UL or DL direction within the last 100msec.
                       from 
                            NOKLTE_PS_LEPSB_lncel_hour PMRAW
                            INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                  
                      where
                     
                      period_start_time >= to_date(&start_datetime, 'yyyymmdd')
                   and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                      group by to_char(period_start_time, 'yyyymmdd'),
                       to_char(period_start_time, 'hh24'),
                               PMRAW.lncel_id,
                               to_char(period_start_time, 'yyyymmdd')||  to_char(period_start_time, 'hh24') || PMRAW.lncel_id) M8006,
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime,
                    to_char(period_start_time, 'hh24') TTime,
                           PMRAW.lncel_id,
                           to_char(period_start_time, 'yyyymmdd') ||  to_char(period_start_time, 'hh24') || PMRAW.lncel_id cel_key_id,
                           sum(nvl(REJ_RRC_CONN_RE_ESTAB, 0)) M8008C0 --The number of rejected RRC Connection re-establishments.
                          ,
                           sum(nvl(RRC_PAGING_REQUESTS, 0)) M8008C1 --The number of RRC paging requests (records).
                          ,
                           sum(nvl(DISC_RRC_PAGING, 0)) M8008C2 --The number of discarded RRC paging requests (records).
                          ,
                           sum(nvl(RRC_PAGING_MESSAGES, 0)) M8008C3 --The number of transmitted RRC paging messages.
                          ,
                           sum(nvl(RRC_CON_RE_ESTAB_ATT, 0)) M8008C4 --The number of attempted RRC Connection Re-establishment procedures.
                          ,
                           sum(nvl(RRC_CON_RE_ESTAB_SUCC, 0)) M8008C5 --The number of successful RRC Connection Re-establishment procedures.
                          ,
                           sum(nvl(RRC_CON_RE_ESTAB_ATT_HO_FAIL, 0)) M8008C6 --The number of RRC Connection Re-establishment attempts per cause (Handover Failure).
                          ,
                           sum(nvl(RRC_CON_RE_ESTAB_SUCC_HO_FAIL, 0)) M8008C7 --The number of successful RRC Connection Re-establishment procedures per cause (Handover Failure).
                          ,
                           sum(nvl(RRC_CON_RE_ESTAB_ATT_OTHER, 0)) M8008C8 --The number of RRC Connection Re-establishment attempts per cause (Other failure).
                          ,
                           sum(nvl(RRC_CON_RE_ESTAB_SUCC_OTHER, 0)) M8008C9 --The number of successful RRC Connection Re-establishment procedures per cause (Other Failure).
                          ,
                           sum(nvl(REPORT_CGI_REQ, 0)) M8008C10 --This counter provides the total number of attempts to retrieve the CGI of a neighbor cell from UE.
                          ,
                           sum(nvl(SUCC_CGI_REPORTS, 0)) M8008C11 --This counter provides the number of CGI measurement reports received from UE.
                      from 
                            NOKLTE_PS_LRRC_lncel_hour PMRAW
                            INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                  
                     where period_start_time >= to_date(&start_datetime, 'yyyymmdd')
                       and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                     group by to_char(period_start_time, 'yyyymmdd'),
                      to_char(period_start_time, 'hh24'),
                              PMRAW.lncel_id,
                              to_char(period_start_time, 'yyyymmdd')||to_char(period_start_time, 'hh24') || PMRAW.lncel_id) M8008,
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime,
                    to_char(period_start_time, 'hh24') TTime,
                           PMRAW.lncel_id,
                           to_char(period_start_time, 'yyyymmdd') ||  to_char(period_start_time, 'hh24') || PMRAW.lncel_id cel_key_id,
                           sum(nvl(TOT_NOT_START_HO_PREP, 0)) M8009C0 --The number of not started Handover preparations. The RRM receives an RRC Measurement Report (UE -; eNB), but the RRM decides not to start a Handover preparation phase. No target cell list will be handed over to the mobility management (MM) unit.
                          ,
                           sum(nvl(TOT_HO_DECISION, 0)) M8009C1 --The number of positive Handover decisions. In case of a positive Handover decision, the RRM transmits a target cell list to the mobility management (MM) unit.
                          ,
                           sum(nvl(INTRA_ENB_HO_PREP, 0)) M8009C2 --The number of Intra-eNB Handover preparations.
                          ,
                           sum(nvl(FAIL_ENB_HO_PREP_AC, 0)) M8009C3 --The number of failed Intra-eNB Handover preparations due to Admission Control. Includes failures to set up data forwarding in the target cell.
                          ,
                           sum(nvl(FAIL_ENB_HO_PREP_OTH, 0)) M8009C5 --The number of failed Intra-eNB Handover preparations due to other reasons.
                          ,
                           sum(nvl(ATT_INTRA_ENB_HO, 0)) M8009C6 --The number of Intra-eNB Handover attempts.
                          ,
                           sum(nvl(SUCC_INTRA_ENB_HO, 0)) M8009C7 --The number of successful Intra-eNB Handover completions.
                          ,
                           sum(nvl(ENB_INTRA_HO_FAIL, 0)) M8009C8 --The number of Intra-eNB Handover failures due to the guarding timer THOoverall.
                          ,
                           sum(nvl(ENB_HO_DROP_RLFAIL, 0)) M8009C12 --The number of Intra-eNB Handover drops due to Radio Link Failure.
                          ,
                           sum(nvl(ENB_HO_DROP_OTHERFAIL, 0)) M8009C13 --The number of Intra-eNB Handover drops due to other failures.
                      from 
                            NOKLTE_PS_LIANBHO_lncel_hour PMRAW
                            INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                  
                      
                     where period_start_time >= to_date(&start_datetime, 'yyyymmdd')
                       and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                     group by to_char(period_start_time, 'yyyymmdd'),
                      to_char(period_start_time, 'hh24') ,
                              PMRAW.lncel_id,
                              to_char(period_start_time, 'yyyymmdd') ||  to_char(period_start_time, 'hh24') || PMRAW.lncel_id) M8009,
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime,
                    to_char(period_start_time, 'hh24') TTime,
                            PMRAW.lncel_id,
                            to_char(period_start_time, 'yyyymmdd') ||  to_char(period_start_time, 'hh24') || PMRAW.lncel_id cel_key_id,
                            sum(nvl(PRB_USED_PUSCH, 0)) M8011C50 --Total number of used PRB's for PUSCH scheduling over the measurement period.
                            ,
                             sum(nvl(PRB_USED_PDSCH, 0)) M8011C54 --Total number of used PRB's for PDSCH scheduling over the measurement period.
                       from 
                       
                            NOKLTE_PS_LCELLR_lncel_hour PMRAW
                            INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                  
                      where
                     
                      period_start_time >= to_date(&start_datetime, 'yyyymmdd')
                   and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                      group by to_char(period_start_time, 'yyyymmdd'),
                       to_char(period_start_time, 'hh24'),
                               PMRAW.lncel_id,
                               to_char(period_start_time, 'yyyymmdd') ||  to_char(period_start_time, 'hh24')|| PMRAW.lncel_id
                     
                     ) M8011,
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime,
                    to_char(period_start_time, 'hh24') TTime,
                            PMRAW.lncel_id,
                            to_char(period_start_time, 'yyyymmdd') || to_char(period_start_time, 'hh24') || PMRAW.lncel_id cel_key_id,
                            sum(nvl(PDCP_SDU_VOL_UL, 0)) M8012C19 --The measurement gives an indication of the eUu interface traffic load by reporting the total received PDCP SDU-related traffic volume.
                           ,
                            sum(nvl(PDCP_SDU_VOL_DL, 0)) M8012C20 --The measurement gives an indication of the eUu interface traffic load by reporting the total transmitted PDCP SDU-related traffic volume.
                       from 
                       
                            NOKLTE_PS_LCELLT_lncel_hour PMRAW
                            INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                  
                       
                      where
                     
                      period_start_time >= to_date(&start_datetime, 'yyyymmdd')
                   and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                      group by to_char(period_start_time, 'yyyymmdd'),
                       to_char(period_start_time, 'hh24'),
                               PMRAW.lncel_id,
                               to_char(period_start_time, 'yyyymmdd')|| to_char(period_start_time, 'hh24') || PMRAW.lncel_id) M8012,
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime,
                   to_char(period_start_time, 'hh24') TTime,
                           PMRAW.lncel_id,
                           to_char(period_start_time, 'yyyymmdd') ||to_char(period_start_time, 'hh24')|| PMRAW.lncel_id cel_key_id,
                           sum(nvl(SIGN_CONN_ESTAB_COMP, 0)) M8013C5 --The number of Signaling Connection Establishment completions with the UE target to be in the ECM-CONNECTED state.
                          ,
                           sum(nvl(SIGN_EST_F_RRCCOMPL_MISSING, 0)) M8013C6 --The number of Signaling Connection Establishment failures due to a missing RRC CONNECTION SETUP COMPLETE message. The UE has not reached the ECM-CONNECTED state.
                          ,
                           sum(nvl(SIGN_EST_F_RRCCOMPL_ERROR, 0)) M8013C7 --The number of Signaling Connection Establishment failures due to the Erroneous or incomplete RRC CONNECTION SETUP COMPLETE message. The UE has not reached the ECM-CONNECTED state.
                          ,
                           sum(nvl(SIGN_CONN_ESTAB_FAIL_RRMRAC, 0)) M8013C8 --The number of Signaling Connection Establishment failures due to Rejection by RRM RAC. The UE has not reached the ECM-CONNECTED state.
                          ,
                           sum(nvl(EPC_INIT_TO_IDLE_UE_NORM_REL, 0)) M8013C9 --The number of EPC-initiated transitions to the ECM-IDLE state due to a Normal release by the UE .
                          ,
                           sum(nvl(EPC_INIT_TO_IDLE_DETACH, 0)) M8013C10 --The number of EPC-initiated transitions to the ECM-IDLE state due to the Detach procedure by the UE or the MME .
                          ,
                           sum(nvl(EPC_INIT_TO_IDLE_RNL, 0)) M8013C11 --The number of EPC initiated transitions to ECM-IDLE state due to Radio Network Layer cause. The UE-associated logical S1-connection is released.
                          ,
                           sum(nvl(EPC_INIT_TO_IDLE_OTHER, 0)) M8013C12 --The number of EPC-initiated transitions to the ECM-IDLE state due to Other causes.
                          ,
                           sum(nvl(ENB_INIT_TO_IDLE_NORM_REL, 0)) M8013C13 --The number of eNB-initiated transitions from the ECM-CONNECTED to ECM-IDLE state due to User Inactivity or Redirect. The UE-associated logical S1-connection is released.
                          ,
                           sum(nvl(ENB_INIT_TO_IDLE_RNL, 0)) M8013C15 --The number of eNB initiated transitions from the ECM-CONNECTED to ECM-IDLE state when the Radio Connection to the UE is lost. The UE-associated logical S1-connection is released.
                          ,
                           sum(nvl(ENB_INIT_TO_IDLE_OTHER, 0)) M8013C16 --The number of eNB-initiated transitions from the ECM-CONNECTED to ECM-IDLE state due to Other causes than User Inactivity, Redirect or Radio Connection Lost.
                          ,
                           sum(nvl(SIGN_CONN_ESTAB_ATT_MO_S, 0)) M8013C17 --The number of Signaling Connection Establishment attempts for mobile originated signaling. From UE's point of view, the transition from ECM-IDLE to ECM-CONNECTED has started.
                            ,
                             sum(nvl(SIGN_CONN_ESTAB_ATT_MT, 0)) M8013C18 --The number of Signaling Connection Establishment attempts for mobile terminated connections. From UE's point of view, the transition from ECM-IDLE to ECM-CONNECTED is started.
                          ,
                           sum(nvl(SIGN_CONN_ESTAB_ATT_MO_D, 0)) M8013C19 --The number of Signaling Connection Establishment attempts for mobile originated data connections. From UE's point of view, the transition from ECM-IDLE to ECM-CONNECTED is started.
                            ,
                             sum(nvl(SIGN_CONN_ESTAB_ATT_OTHERS, 0)) M8013C20 --The number of Signaling Connection Establishment attempts due to other reasons. From UE's point of view, the transition from ECM-IDLE to ECM-CONNECTED is started.
                          ,
                           sum(nvl(SIGN_CONN_ESTAB_ATT_EMG, 0)) M8013C21 --Number of Signalling Connection Establishment attempts for emergency calls
                          ,
                           sum(nvl(SUBFRAME_DRX_ACTIVE_UE, 0)) M8013C24 --The number of subframes, when UE is DRX Active.
                          ,
                           sum(nvl(SUBFRAME_DRX_SLEEP_UE, 0)) M8013C25 --The number of subframes, when UE is DRX Sleep (i.e. not DRX Active).
                          ,
                           sum(nvl(SIGN_CONN_ESTAB_COMP_EMG, 0)) M8013C26 --The number of Signalling Connection Establishment completions for emergency calls
                          ,
                           sum(nvl(SIGN_CONN_ESTAB_FAIL_RB_EMG, 0)) M8013C27 --The number of Signalling Connection Establishment failures for emergency calls due to missing RB (Radio Bearer) resources
                          ,
                           sum(nvl(PRE_EMPT_UE_CONTEXT_NON_GBR, 0)) M8013C28 --This measurement provides the number of UE contexts being released due to lack of radio resources.
                          ,
                           c.lnbtsid as  enb_id,
                           c.lncel_lcr_id as  cell_id,
                           c.version as  bts_version,
                           c.lnbts_name as cel_name,
                    (CASE 
                    WHEN (c.city = 'Baoji' AND c.netmodel = 'FDD') THEN '宝鸡FDD'
                    WHEN (c.city = 'Baoji' AND c.netmodel = 'TDD') THEN '宝鸡TDD'
                    WHEN (c.city = 'Xian' AND c.netmodel = 'FDD') THEN '西安FDD'
                    WHEN (c.city = 'Xian' AND c.netmodel = 'TDD') THEN '西安TDD'
                    WHEN (c.city = 'Xianyang' AND c.netmodel = 'FDD') THEN '咸阳FDD'
                    WHEN (c.city = 'Hanzhong' AND c.netmodel = 'TDD') THEN '汉中TDD'
                    WHEN (c.city = 'Yulin' AND c.netmodel = 'TDD') THEN '榆林TDD'
                    WHEN (c.city = 'Yanan' AND c.netmodel = 'TDD') THEN '延安TDD'

                    WHEN (c.city = 'Tongchuan' AND c.netmodel = 'TDD') THEN '铜川TDD'

                    WHEN (c.city = 'Shangluo' AND c.netmodel = 'TDD') THEN '商洛TDD'            
                ELSE NULL END) 区域,
                           c.lnbts_name as bts_name
                      from NOKLTE_PS_LUEST_lncel_hour PMRAW
                           inner join c_lte_custom c on PMRAW.LNCEL_ID = c.lncel_objid
                           INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                  
                     where period_start_time >=to_date(&start_datetime, 'yyyymmdd')
                            and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                    --AND PERIOD_DURATION=15
                     group by to_char(period_start_time, 'yyyymmdd'),
                              to_char(period_start_time, 'hh24'),
                              PMRAW.LNCEL_ID,
                              c.lnbtsid,
                              c.lncel_lcr_id,
                              c.version,
                              c.netmodel,
                              c.city,
                              c.lnbts_name
                   
                   
                   ) M8013,
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime,
                    to_char(period_start_time, 'hh24') TTime,
                            PMRAW.lncel_id,
                            to_char(period_start_time, 'yyyymmdd') || to_char(period_start_time, 'hh24') || PMRAW.lncel_id cel_key_id,
                            sum(nvl(INTER_ENB_HO_PREP, 0)) M8014C0 --The number of Inter-eNB X2-based Handover preparations. The Mobility management (MM) receives a list with target cells from the RRM and decides to start an Inter-eNB X2-based Handover.
                           ,
                            sum(nvl(FAIL_ENB_HO_PREP_TIME, 0)) M8014C2 --The number of failed Inter-eNB X2-based Handover preparations due to timer TX2RELOCprep.
                           ,
                            sum(nvl(FAIL_ENB_HO_PREP_AC, 0)) M8014C3 --The number of failed Inter-eNB X2-based Handover preparations due to the target eNB's admission control reasons.
                            ,
                             sum(nvl(FAIL_ENB_HO_PREP_OTHER, 0)) M8014C5 --The number of failed Inter-eNB X2-based Handover preparations due to the target eNB's other reasons.
                           ,
                            sum(nvl(ATT_INTER_ENB_HO, 0)) M8014C6 --The number of Inter-eNB X2-based Handover attempts.
                           ,
                            sum(nvl(SUCC_INTER_ENB_HO, 0)) M8014C7 --The number of successful Inter-eNB X2-based Handover completions.
                           ,
                            sum(nvl(INTER_ENB_HO_FAIL, 0)) M8014C8 --Number of Inter eNB Handover failures due to expiration of guarding timer TX2RELOCoverall
                           ,
                            sum(nvl(INTER_ENB_S1_HO_PREP, 0)) M8014C14 --The number of Inter eNB S1-based Handover preparations
                           ,
                            sum(nvl(INTER_S1_HO_PREP_FAIL_TIME, 0)) M8014C15 --The number of failed Inter eNB S1-based Handover preparations due to the expiry of the guarding timer TS1RELOCprep.
                           ,
                            sum(nvl(INTER_S1_HO_PREP_FAIL_NORR, 0)) M8014C16 --The number of failed Inter eNB S1-based Handover preparations with cause No Radio Resources Available in Target Cell.
                           ,
                            sum(nvl(INTER_S1_HO_PREP_FAIL_OTHER, 0)) M8014C17 --The number of failed Inter eNB S1-based Handover preparations due to the reception of an S1AP: HANDOVER PREPARATION FAILURE message with a cause other than No Radio Resources Available in Target Cell.
                           ,
                            sum(nvl(INTER_ENB_S1_HO_ATT, 0)) M8014C18 --The number of Inter eNB S1-based Handover attempts
                           ,
                            sum(nvl(INTER_ENB_S1_HO_SUCC, 0)) M8014C19 --The number of successful Inter eNB S1-based Handover completions
                           ,
                            sum(nvl(INTER_ENB_S1_HO_FAIL, 0)) M8014C20 --The number of Inter eNB S1-based Handover failures
                       from 
                       
                       NOKLTE_PS_LIENBHO_lncel_hour PMRAW
                       INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                  
                      where
                     
                      period_start_time >= to_date(&start_datetime, 'yyyymmdd')
                   and period_start_time < to_date(&end_datetime, 'yyyymmdd')                 
                      group by to_char(period_start_time, 'yyyymmdd'),
                       to_char(period_start_time, 'hh24'),
                               PMRAW.lncel_id,
                               to_char(period_start_time, 'yyyymmdd') ||  to_char(period_start_time, 'hh24') || PMRAW.lncel_id) M8014,
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime,
                    to_char(period_start_time, 'hh24') TTime,
                           PMRAW.lncel_id,
                           to_char(period_start_time, 'yyyymmdd') ||  to_char(period_start_time, 'hh24') || PMRAW.lncel_id cel_key_id,
                           sum(nvl(INTRA_HO_SUCC_NB, 0)) M8015C2 --The number of successful Intra-eNB Handover completions per neighbour cell relationship.
                          ,
                           sum(nvl(INTER_HO_SUCC_NB, 0)) M8015C9 --The number of successful Inter eNB Handover completions per neighbour cell relationship
                          ,
                           SUM(NVL(INTER_HO_PREP_FAIL_OTH_NB, 0)) M8015C5 --The number of failed Inter eNB Handover preparations per cause per neighbour cell relationship
                          ,
                           SUM(NVL(INTER_HO_PREP_FAIL_TIME_NB, 0)) M8015C6 --The number of failed Inter eNB Handover preparations per neighbour cell relationship due to the expiration of the respective guarding timer.
                          ,
                           SUM(NVL(INTER_HO_PREP_FAIL_AC_NB, 0)) M8015C7 --The number of failed Inter eNB Handover preparations per neighbour cell relationship due to failures in the HO preparation on the target side
                          ,
                           SUM(NVL(INTER_HO_ATT_NB, 0)) M8015C8 --The number of Inter eNB Handover attempts per neighbour cell relationship
                    
                      from 
                      
                            NOKLTE_PS_LNCELHO_lncel_hour PMRAW
                            INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                  
                     where period_start_time >= to_date(&start_datetime, 'yyyymmdd')
                       and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                     group by to_char(period_start_time, 'yyyymmdd'),
                      to_char(period_start_time, 'hh24') ,
                              PMRAW.lncel_id,
                              to_char(period_start_time, 'yyyymmdd') || to_char(period_start_time, 'hh24') || PMRAW.lncel_id) M8015,
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime,
                    to_char(period_start_time, 'hh24') TTime,
                           PMRAW.lncel_id,
                           to_char(period_start_time, 'yyyymmdd')||  to_char(period_start_time, 'hh24') || PMRAW.lncel_id cel_key_id,
                           sum(nvl(CSFB_REDIR_CR_ATT, 0)) M8016C11 --The number of CS Fallback attempts with redirection via the RRC Connection Release
                          ,
                           sum(nvl(CSFB_REDIR_CR_CMODE_ATT, 0)) M8016C12 --The number of CS Fallback attempts (UE in Connected Mode) with redirection via the RRC Connection Release
                          ,
                           sum(nvl(CSFB_REDIR_CR_EMERGENCY_ATT, 0)) M8016C13 --The number of CS Fallback attempts for emergency call reason with redirection via the RRC Connection Release
                          ,
                           sum(nvl(ISYS_HO_PREP, 0)) M8016C14 --Number of Inter System Handover preparations.
                          ,
                           sum(nvl(ISYS_HO_PREP_FAIL_TIM, 0)) M8016C15 --Number of failed Inter System Handover preparations due to expiration of guarding timer.
                          ,
                           sum(nvl(ISYS_HO_PREP_FAIL_AC, 0)) M8016C16 --Number of failed Inter System Handover preparations due to admission control of target cell.
                          ,
                           sum(nvl(ISYS_HO_PREP_FAIL_OTH, 0)) M8016C17 --Number of failed Inter System Handover preparations due to other reasons of target cell.
                          ,
                           sum(nvl(ISYS_HO_ATT, 0)) M8016C21 --Number of Inter System Handover attempts.
                          ,
                           sum(nvl(ISYS_HO_SUCC, 0)) M8016C23 --Number of successful Inter System Handover completions.
                          ,
                           sum(nvl(ISYS_HO_FAIL, 0)) M8016C25 --Number of failed Inter System Handover attempts.
                          ,
                           sum(nvl(NACC_TO_GSM_ATT, 0)) M8016C26 --This measurement provides the number of NACC from LTE to GSM attempts
                          ,
                           sum(nvl(NACC_TO_GSM_SUCC, 0)) M8016C27 --This measurement provides the number of successful NACC from LTE to GSM completions
                          ,
                           sum(nvl(NACC_TO_GSM_FAIL, 0)) M8016C28 --This measurement provides the number of failed NACC from LTE to GSM.
                          ,
                           sum(nvl(ISYS_HO_UTRAN_SRVCC_ATT, 0)) M8016C29 --This measurement provides the number of Inter System Handover attempts to UTRAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
                          ,
                           sum(nvl(ISYS_HO_UTRAN_SRVCC_SUCC, 0)) M8016C30 --This measurement provides the number of successful Inter System Handover completions to UTRAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
                          ,
                           sum(nvl(ISYS_HO_UTRAN_SRVCC_FAIL, 0)) M8016C31 --This measurement provides the number of failed Inter System Handover attempts to UTRAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
                          ,
                           sum(nvl(CSFB_PSHO_UTRAN_ATT, 0)) M8016C32 --This measurement provides the number of CS Fallback attempts to UTRAN with PS Handover (Circuit Switched Fallback in Evolved Packet System, 3GPP TS 23.272).
                          ,
                           sum(nvl(ISYS_HO_GERAN_SRVCC_ATT, 0)) M8016C33 --This measurement provides the number of Inter System Handover attempts to GERAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
                          ,
                           sum(nvl(ISYS_HO_GERAN_SRVCC_SUCC, 0)) M8016C34 --This measurement provides the number of successful Inter System Handover completions to GERAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
                          ,
                           sum(nvl(ISYS_HO_GERAN_SRVCC_FAIL, 0)) M8016C35 --This measurement provides the number of failed Inter System Handover attempts to GERAN with SRVCC (Single Radio Voice Call Continuity, 3GPP TS 23.216).
                      from 
                            NOKLTE_PS_LISHO_lncel_hour PMRAW
                            INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                  
                     where period_start_time >= to_date(&start_datetime, 'yyyymmdd')
                       and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                     group by to_char(period_start_time, 'yyyymmdd'),                 
                      to_char(period_start_time, 'hh24') ,
                              PMRAW.lncel_id,
                              to_char(period_start_time, 'yyyymmdd') || to_char(period_start_time, 'hh24')|| PMRAW.lncel_id) M8016,
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime ,
                    to_char(period_start_time, 'hh24') TTime,
                           LNBTS_ID,
                           PMRAW.lncel_id,
                           to_char(period_start_time, 'yyyymmdd')|| to_char(period_start_time, 'hh24') || PMRAW.lncel_id cel_key_id,
                           sum(nvl(CHNG_TO_CELL_AVAIL, 0)) M8020C0 --Number of cell state changes to cell is available
                          ,
                           sum(nvl(CHNG_TO_CELL_PLAN_UNAVAIL, 0)) M8020C1 --Number of cell state changes to cell is planned unavailable
                          ,
                           sum(nvl(CHNG_TO_CELL_UNPLAN_UNAVAIL, 0)) M8020C2 --Number of cell state changes to cell is unplanned unavailable
                          ,
                           sum(nvl(SAMPLES_CELL_AVAIL, 0)) M8020C3 --The number of samples when the cell is available
                          ,
                           sum(nvl(SAMPLES_CELL_PLAN_UNAVAIL, 0)) M8020C4 --The number of samples when the cell is planned unavailable
                          ,
                           sum(nvl(SAMPLES_CELL_UNPLAN_UNAVAIL, 0)) M8020C5 --The number of samples when the cell is unplanned unavailable
                          ,
                           sum(nvl(DENOM_CELL_AVAIL, 0)) M8020C6 --The number of samples when cell availability is checked. This counter is used as a denominator for the cell availability calculation
                      from 
                      
                            NOKLTE_PS_LCELAV_LNCEL_HOUR PMRAW
                            INNER JOIN busyhour ON busyhour.lncel_id = PMRAW.lncel_id and busyhour.pm_date_hour = to_char(PMRAW.period_start_time, 'yyyymmddhh24')
                  
                     where period_start_time >= to_date(&start_datetime, 'yyyymmdd')
                       and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                     group by to_char(period_start_time, 'yyyymmdd'),
                      to_char(period_start_time, 'hh24') ,
                              MRBTS_ID,
                              LNBTS_ID,
                              PMRAW.lncel_id,
                              to_char(period_start_time, 'yyyymmdd') || to_char(period_start_time, 'hh24') || PMRAW.lncel_id) M8020, 
                   (select to_char(period_start_time, 'yyyymmdd') sdatetime,
                       to_char(period_start_time, 'hh24') TTime,
                               LNBTS_ID,
                               LHO.lncel_id,
                               to_char(period_start_time, 'yyyymmdd') || to_char(period_start_time, 'hh24')|| LHO.lncel_id cel_key_id,
                               sum(nvl(HO_INTFREQ_ATT, 0)) M8021C0, 
                               sum(nvl(HO_INTFREQ_SUCC, 0)) M8021C2
                              

                          from 
                               NOKLTE_PS_LHO_LNCEL_HOUR  LHO
                               INNER JOIN busyhour ON busyhour.lncel_id = LHO.lncel_id and busyhour.pm_date_hour = to_char(LHO.period_start_time, 'yyyymmddhh24')
                  
                         where period_start_time >=
                               to_date(&start_datetime, 'yyyymmdd')
                           and period_start_time < to_date(&end_datetime, 'yyyymmdd')
                         group by to_char(period_start_time, 'yyyymmdd'),
                         to_char(period_start_time, 'hh24'),
                                  MRBTS_ID,
                                  LNBTS_ID,
                                  LHO.lncel_id,
                                  to_char(period_start_time, 'yyyymmdd') || to_char(period_start_time, 'hh24')|| LHO.lncel_id) M8021                          
                                               
                              
                                     
             WHERE M8013.cel_key_id = m8001.cel_key_id(+)
               AND M8013.cel_key_id = m8006.cel_key_id(+)
               AND M8013.cel_key_id = m8008.cel_key_id(+)
               AND M8013.cel_key_id = m8009.cel_key_id(+)
               AND M8013.cel_key_id = m8011.cel_key_id(+)
               AND M8013.cel_key_id = m8012.cel_key_id(+)
               AND M8013.cel_key_id = m8014.cel_key_id(+)
               AND M8013.cel_key_id = m8015.cel_key_id(+)
               AND M8013.cel_key_id = m8016.cel_key_id(+)
               AND M8013.cel_key_id = m8020.cel_key_id(+)
               AND M8013.cel_key_id = m8021.cel_key_id(+)
               
               )kkkk
     GROUP BY sdatetime,
              TTime,
              kkkk.bts_version,
              kkkk.区域
              --enb_id
              --enb_cell
    ) city

group by 
    &start_datetime||'_'||&end_datetime,
    --TTime,
    区域

