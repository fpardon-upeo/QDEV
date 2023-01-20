/**
 * @Version: 1.0
 * @Author: Frederik
 * @Copyright: 2021 Upeo Consulting
 * @Uses:
 *
 * -----------------------------------------------------------------------------------------------
 * Description: 
 *
 *
 * Created: 24/11/2022
 * Last Updated: 24/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
@Description:

@Change Log:

@Dependencies:

@Test Classes:

*/

public class WebCareArticlePriceSyncBatch implements Database.Batchable<WebCareArticlePrice.Article>, Database.AllowsCallouts, Database.Stateful {

    public Integer pageNumber;
    public Boolean isLastBatch;

    public WebCareArticlePriceSyncBatch(Integer pageNumber) {
        this.pageNumber = pageNumber;
    }

    public List<WebCareArticlePrice.Article> start(Database.BatchableContext BC){
        system.debug('start, pageNumber: ' + pageNumber);
        WebCareArticlePriceSync webCareArticlePriceSync = new WebCareArticlePriceSync();
        WebCareArticlePrice returnResult = webCareArticlePriceSync.startSync(pageNumber);
        List<WebCareArticlePrice.Article> wcap =  returnResult.articles;
        system.debug('count = ' + returnResult.count);
        if(wcap != null && returnResult.count >= 499){
            isLastBatch = false;
            System.debug('isLastBatch: ' + isLastBatch + ' and should not be the last batch');
            pageNumber++;
        } else {
            system.debug('isLastBatch: ' + isLastBatch + ' and should be the last batch');
            isLastBatch = true;
        }
        return wcap;
    }

    public void execute(Database.BatchableContext BC, List<WebCareArticlePrice.Article> scope){

        WebCareArticlePriceSync wcaps = new WebCareArticlePriceSync();
        wcaps.init();
        wcaps.transformArticlePrices(scope);
        System.debug('Executing batch');
    }

    public void finish(Database.BatchableContext BC){

        system.debug('Finished batch ' +isLastBatch + ' and page number: ' + pageNumber);
        if(isLastBatch == false){
            system.debug('Starting next batch');
            //WebCareArticleSyncBatch wcasb = new WebCareArticleSyncBatch(pageNumber);
            Id batchJobId = Database.executeBatch(new WebCareArticlePriceSyncBatch(pageNumber), 500);
        }
        if (isLastBatch == true){
            system.debug('Finished all batches');
            List<PricebookEntry> pbe = [SELECT Id, IsActive FROM PricebookEntry WHERE LastModifiedDate < LAST_N_DAYS:1];
            for(PricebookEntry p : pbe){
                p.IsActive = false;
            }
            update pbe;
        }

    }
}