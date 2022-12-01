library(ovml)
img <- ovml_example_image()
ovml_ggplot(img)
dn <- ovml_yolo()

dets <- ovml_yolo_detect(dn, img, conf = 0.3)
dets <- dets[dets$class %in% c("person", "sports ball"), ]
ovml_ggplot(img, dets)


dn <- ovml_yolo("4-mvb")
ball_dets <- ovml_yolo_detect(dn, img)
ovml_ggplot(img, ball_dets, label_geom = NULL) ## don't add the label, it obscures the volleyball

library(ovideo)
ref <- ov_shiny_court_ref(img)


court_xy <- ov_transform_points(x = (dets$xmin + dets$xmax) / 2 / ref$video_width,
                                        y = dets$ymin / ref$video_height,
                                        ref = ref$court_ref, direction = "to_court")
dets <- cbind(dets, court_xy)

library(datavolley)
library(ggplot2)
ggplot(dets, aes(x, y)) + ggcourt(labels = NULL, court_colour = "indoor") + geom_point()
