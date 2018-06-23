using VisualDL

train_logger = VisualDLLogger("tmp", 1, "train")
test_logger = as_mode(train_logger, "test")

for i in 1:100
    with_logger(train_logger) do
        @log_scalar s0=(i,rand()) s1=(i, rand())
    end

    with_logger(test_logger) do
        @log_scalar s0=(i,rand()) s1=(i, rand())
    end
end

for i in 1:100
    with_logger(train_logger) do
       @log_histogram h0=(i, randn(100))
    end
end

for i in 1:100
    with_logger(train_logger) do
       @log_text t0=(i, "This is test " * string(i))
    end
end

for i in 1:100
    with_logger(train_logger) do
       @log_image i0=([3,3,3], rand(27) * 255)
    end
end

for i in 1:100
    with_logger(test_logger) do
        @log_image image0=rand(10, 10, 3) * 255
    end
end

save(train_logger)
save(test_logger)