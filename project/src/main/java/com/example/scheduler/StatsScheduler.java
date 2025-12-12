package com.example.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.service.StatsService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class StatsScheduler {

    @Autowired
    private StatsService statsService;

    // 매일 자정 1분에 실행 (00:01:00)
    @Scheduled(cron = "0 1 0 * * *")
    public void generateDailyStats() {
        log.info("===== 일별 통계 집계 시작 =====");
        try {
            statsService.insertDailyStats();
            log.info("===== 일별 통계 집계 완료 =====");
        } catch (Exception e) {
            log.error("일별 통계 집계 실패", e);
        }
    }
}