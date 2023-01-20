/**
 * Created by fpardon on 19/12/2022.
 */

global class WebCareArticlePriceSchedule Implements Schedulable {

    global void execute(SchedulableContext sc) {
        String jobId = Database.executeBatch(new WebCareArticlePriceSyncBatch(1), 500);
    }
}