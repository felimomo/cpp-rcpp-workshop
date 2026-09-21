library(ggplot2)
library(dplyr)

df <- read.csv(here::here("notes", "glm-benchmarks.csv"))
print(head(df))

p <- (
	ggplot(df, aes(x=n_pred, y=median_s, color=method))
	+ geom_line()
	+ facet_wrap(~n_obs, scales="free")
)
ggsave(
	here::here("notes", "runtime.png"), 
	p, width = 8, height = 5, dpi = 150
)

p <- (
	ggplot(df, aes(x=n_pred, y=mem_mb, color=method))
	+ geom_line()
	+ facet_wrap(~n_obs, scales="free")
	+ scale_y_log10()
)
ggsave(
	here::here("notes", "memory.png"), 
	p, width = 8, height = 5, dpi = 150
)

p <- (
	(
		df |> filter(method != 'qr')
		 	 |> ggplot(aes(x=n_pred, y=max_dev_qr, color=method))
	)
	+ geom_line()
	+ facet_wrap(~n_obs, scales="free")
	+ scale_y_log10()
)

ggsave(
	here::here("notes", "max_dev.png"), 
	p, width = 8, height = 5, dpi = 150
)