# Defines saw operating loop. An operator seizes the saw and starts sawing and
# counting logs in an infinite loop. Use to define each saw operation
# @name    f.saw_logs
# @param   saw  identifier of a saw
# @return  count of logs sawn
# @export
f.saw_logs = function(saw, ptm, pts) {
  trajectory() %>% 
    seize(saw, 1) %>% 
    timeout(function () rnorm(1, ptm, pts)) %>% 
    set_attribute("logs", 1, mod = "+") %>% 
    rollback(2, Inf)
}