package WWW::OpenX::API::Dispatch::Table;
use warnings;
use strict;

# this is a horrid kludge to make sure the right endpoints are being called.
# still not sure why they decided to implement it this way, but oh well.

use constant DISPATCH_TABLE => {
    # authentication
    # login = alias for logon
    logon                                   =>  { 'service' => 'LogonXmlRpcService.php', require_auth => 0, no_implode => 1 },
    logoff                                  =>  { 'service' => 'LogonXmlRpcService.php', require_auth => 1 },
    # agency
    addAgency                               =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    deleteAgency                            =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    getAgency                               =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    getAgencyList                           =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    agencyAdvertiserStatistics              =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    agencyBannerStatistics                  =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    agencyCampaignStatistics                =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    agencyDailyStatistics                   =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    agencyPublisherStatistics               =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    agencyZoneStatistics                    =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    modifyAgency                            =>  { 'service' => 'AgencyXmlRpcService.php', require_auth => 1 },
    # advertiser
    addAdvertiser                           =>  { 'service' => 'AdvertiserXmlRpcService.php', require_auth => 1 },
    deleteAdvertiser                        =>  { 'service' => 'AdvertiserXmlRpcService.php', require_auth => 1 },
    getAdvertiser                           =>  { 'service' => 'AdvertiserXmlRpcService.php', require_auth => 1 },
    advertiserBannerStatistics              =>  { 'service' => 'AdvertiserXmlRpcService.php', require_auth => 1 },
    advertiserCampaignStatistics            =>  { 'service' => 'AdvertiserXmlRpcService.php', require_auth => 1 },
    advertiserDailyStatistics               =>  { 'service' => 'AdvertiserXmlRpcService.php', require_auth => 1 },
    advertiserListByAgencyID                =>  { 'service' => 'AdvertiserXmlRpcService.php', require_auth => 1 },
    advertiserPublisherStatistics           =>  { 'service' => 'AdvertiserXmlRpcService.php', require_auth => 1 },
    advertiserZoneStatistics                =>  { 'service' => 'AdvertiserXmlRpcService.php', require_auth => 1 },
    modifyAdvertiser                        =>  { 'service' => 'AdvertiserXmlRpcService.php', require_auth => 1 },
    # banner
    addBanner                               =>  { 'service' => 'BannerXmlRpcService.php', require_auth => 1 },
    bannerDailyStatistics                   =>  { 'service' => 'BannerXmlRpcService.php', require_auth => 1 },
    bannerPublisherStatistics               =>  { 'service' => 'BannerXmlRpcService.php', require_auth => 1 },
    bannerZoneStatistics                    =>  { 'service' => 'BannerXmlRpcService.php', require_auth => 1 },
    deleteBanner                            =>  { 'service' => 'BannerXmlRpcService.php', require_auth => 1 },
    getBanner                               =>  { 'service' => 'BannerXmlRpcService.php', require_auth => 1 },
    getBannerListByCampaignId               =>  { 'service' => 'BannerXmlRpcService.php', require_auth => 1 },
    getBannerTargeting                      =>  { 'service' => 'BannerXmlRpcService.php', require_auth => 1 },
    modifyBanner                            =>  { 'service' => 'BannerXmlRpcService.php', require_auth => 1 },
    setBannerTargeting                      =>  { 'service' => 'BannerXmlRpcService.php', require_auth => 1 },
    # campaigns
    addCampaign                             =>  { 'service' => 'CampaignXmlRpcService.php', require_auth => 1 },
    deleteCampaign                          =>  { 'service' => 'CampaignXmlRpcService.php', require_auth => 1 },
    getCampaign                             =>  { 'service' => 'CampaignXmlRpcService.php', require_auth => 1 },
    getCampaignBannerStatistics             =>  { 'service' => 'CampaignXmlRpcService.php', require_auth => 1 },
    getCampaignDailyStatistics              =>  { 'service' => 'CampaignXmlRpcService.php', require_auth => 1 },
    getCampaignListByAdvertiserId           =>  { 'service' => 'CampaignXmlRpcService.php', require_auth => 1 },
    getCampaignPublisherStatistics          =>  { 'service' => 'CampaignXmlRpcService.php', require_auth => 1 },
    getCampaignZoneStatistics               =>  { 'service' => 'CampaignXmlRpcService.php', require_auth => 1 },
    modifyCampaign                          =>  { 'service' => 'CampaignXmlRpcService.php', require_auth => 1 },
    # channels
    # publisher
    addPublisher                            =>  { 'service' => 'PublisherXmlRpcService.php', require_auth => 1 },
    deletePublisher                         =>  { 'service' => 'PublisherXmlRpcService.php', require_auth => 1 },
    getPublisher                            =>  { 'service' => 'PublisherXmlRpcService.php', require_auth => 1 },
    getPublisherAdvertiserStatistics        =>  { 'service' => 'PublisherXmlRpcService.php', require_auth => 1 },
    getPublisherBannerStatistics            =>  { 'service' => 'PublisherXmlRpcService.php', require_auth => 1 },
    getPublisherCampaignStatistics          =>  { 'service' => 'PublisherXmlRpcService.php', require_auth => 1 },
    getPublisherDailyStatistics             =>  { 'service' => 'PublisherXmlRpcService.php', require_auth => 1 },
    getPublisherListByAgencyId              =>  { 'service' => 'PublisherXmlRpcService.php', require_auth => 1 },
    getPublisherZoneStatistics              =>  { 'service' => 'PublisherXmlRpcService.php', require_auth => 1 },
    # user 
    addUser                                 =>  { 'service' => 'UserXmlRpcService.php', require_auth => 1 },
    deleteUser                              =>  { 'service' => 'UserXmlRpcService.php', require_auth => 1 },
    getUser                                 =>  { 'service' => 'UserXmlRpcService.php', require_auth => 1 },
    getUserListByAccountId                  =>  { 'service' => 'UserXmlRpcService.php', require_auth => 1 },
    modifyUser                              =>  { 'service' => 'UserXmlRpcService.php', require_auth => 1 },
    updateSsoUserId                         =>  { 'service' => 'UserXmlRpcService.php', require_auth => 1 },
    updateUserEmailBySsoId                  =>  { 'service' => 'UserXmlRpcService.php', require_auth => 1 },
    # zone
    addZone                                 =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    deleteZone                              =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    generateTags                            =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    getZone                                 =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    getZoneAdvertiserStatistics             =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    getZoneBannerStatistics                 =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    getZoneCampaignStatistics               =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    getZoneDailyStatistics                  =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    getZoneListByPublisherId                =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    linkBanner                              =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    linkCampaign                            =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    modifyZone                              =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    unlinkBanner                            =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
    unlinkCampaign                          =>  { 'service' => 'ZoneXmlRpcService.php', require_auth => 1 },
};

1;
