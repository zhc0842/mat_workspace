function data = FetchSnapshotDataFromWindByDates(dates_,w_)
    data = [];
    for i=1:length(dates_)
        date_ = dates_(i);
        data = [data;FetchSnapshotDataFromWindByDate(date_,w_)];
    end
end