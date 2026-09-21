library(ggplot2)
library(dplyr)

df <- read.csv(here::here("notes", "glm-benchmarks.csv"))
print(head(df))

plot_loc <- function(fname){
	return(
		here::here("plots", fname)
	)
}

p <- (
	ggplot(df, aes(x=n_pred, y=median_s, color=method))
	+ geom_line()
	+ facet_wrap(
			~n_obs, 
			scales = "free",
			labeller = label_both
		)
	+ xlab("N. Pred. Vars.")
	+ ylab("Median Runtime (s)")
	+ ggtitle("Linear Model Fit: Per-method runtime scaling")
	+ theme(plot.title = element_text(hjust = 0.5))
	+ scale_color_discrete(
    labels = c(
    	"qr" = "R QR-solver (LAPACK-based)", 
    	"inv" = "Mat. Inv. (C++ Armadillo)", 
    	"dgesv" = "Chol. Fact. (LAPACK dgesv)")
  )
)
ggsave(
	plot_loc("runtime.png"), 
	p, width = 8, height = 5, dpi = 150,
	create.dir = TRUE
)

p <- (
	ggplot(df, aes(x=n_pred, y=mem_mb, color=method))
	+ geom_line()
	+ facet_wrap(
			~n_obs, 
			scales="free",
			labeller = label_both
		)
	+ scale_y_log10()
	+ xlab("N. Pred. Vars.")
	+ ylab("R Memory use (MB)")
	+ ggtitle("Linear Model Fit: Memory usage on the R side")
	+ theme(plot.title = element_text(hjust = 0.5))
)
ggsave(
	plot_loc("memory.png"), 
	p, width = 8, height = 5, dpi = 150,
	create.dir = TRUE
)

p <- (
	(
		df |> filter(method != 'qr')
		 	 |> ggplot(aes(x=n_pred, y=max_dev_qr, color=method))
	)
	+ geom_line()
	+ facet_wrap(
			~n_obs, 
			scales="free",
			labeller = label_both
		)
	+ scale_y_log10()
	+ xlab("N. Pred. Vars.")
	+ ylab("Max dev. w.r. to QR")
	+ ggtitle("Linear Model Fit: Error scaling")
	+ theme(plot.title = element_text(hjust = 0.5))
)
ggsave(
	plot_loc("max_dev.png"), 
	p, width = 8, height = 5, dpi = 150,
	create.dir = TRUE
)