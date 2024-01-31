if (fastly.ff.visits_this_service == 0) {
  call increment_pageview_counter;
}