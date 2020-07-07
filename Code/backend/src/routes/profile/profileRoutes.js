import { Router } from "express";
import { validateUpdateData } from "./profileValidators";
import {
  handleImageUpload,
  getImageForUser,
} from "../../util/imageUploadService";
import { initUploadInMemory } from "../../config/imageUploadConfig";
import User from "../../models/user";
import composeErrorResponse from "../../util/composeErrorResponse";
import composeSuccessResponse from "../../util/successResponse";

const profileRouter = Router();
const uploadInMemory = initUploadInMemory();

/**
 * @swagger
 * /api/profile:
 *    get:
 *      summary: Gets logged in user profile information
 *      tags:
 *        - profile
 *      consumes:
 *        - application/json
 *      parameters:
 *        - in: header
 *          name: Authorization
 *          type: JWT Bearer
 *      responses:
 *        200:
 *          description: the logged in user profile information
 */
profileRouter.get("/", (req, res) => {
  const { firstName, lastName, email, phoneNumber, emailVerified } = req.user;
  res.status(200).send({
    firstName,
    lastName,
    email,
    phoneNumber,
    emailVerified,
  });
});

/**
 * @swagger
 * /api/profile/update:
 *    post:
 *      summary: Updates properties on user object
 *      description: Updates the properties that are given within the request
 *      tags:
 *        - profile
 *      consumes:
 *        - application/json
 *      parameters:
 *        - in: header
 *          name: Authorization
 *          type: JWT Bearer
 *        - in: body
 *          name: profile info to change
 *          description:
 *          schema:
 *            type: object
 *            properties:
 *              firstName:
 *                type: string
 *                required: false
 *              lastName:
 *                required: false
 *                type: string
 *              email:
 *                required: false
 *                type: string
 *              phoneNumber:
 *                required: false
 *                type: string
 *      responses:
 *        200:
 *          description: Success response
 *        400:
 *          description: fail with error message(s)
 */
profileRouter.post("/update", async (req, res) => {
  const validation = validateUpdateData(req.body);
  if (validation) {
    return res.send(composeErrorResponse(validation, 400));
  }

  await User.updateData(req.body, req.user);
  return res.send(composeSuccessResponse("User info updated successfully"));
});

/**
 * @swagger
 * /api/profile/profile-image:
 *    get:
 *      summary: gets profile image for the user
 *      tags:
 *        - profile
 *      consumes:
 *        - application/json
 *      parameters:
 *        - in: header
 *          name: Authorization
 *          type: JWT Bearer
 *      responses:
 *        200:
 *          description: the logged in user profile information
 *        400:
 *          description: Error getting profile image
 */
profileRouter.get("/profile-image", async (req, res) => {
  // If there's no profile picture set
  if (!req.user.profileImageLocation) {
    return res.send({
      success: false,
      msg: "show default photo cause no photo",
    });
  }

  const fileStream = await getImageForUser(req.user.profileImageLocation);
  // Image is for some reason not on cloud
  if (fileStream == null) {
    await req.user.updateProfileImageLocation(null);
    return res.status(400).send({
      success: false,
      msg: "Profile image not found",
    });
  }
  // send image
  fileStream.pipe(res);
});

/**
 * @swagger
 * /api/profile/upload-image:
 *    post:
 *      summary: Upload users new profile image
 *      tags:
 *        - profile
 *      parameters:
 *        - in: header
 *          name: Authorization
 *          type: JWT Bearer
 *        - in: formData
 *          name: image
 *          type: file
 *          description: the to-be profile image of the user
 *      responses:
 *        200:
 *          description: image uploaded successfully
 *        400:
 *          description: fail to upload image
 */
profileRouter.post(
  "/upload-image",
  uploadInMemory.single("image"),
  async (req, res) => {
    if (!req.file) {
      console.log("No file received");
      return res.send({
        success: false,
        msg: "No file received",
      });
    } else {
      const filename = await handleImageUpload(req.file, req.user._id);
      if (filename == null) {
        return res.status(400).send({
          success: false,
          msg: "error uploading to cloud",
        });
      }
      console.log(filename);
      await req.user.updateProfileImageLocation(filename);
      return res.send({
        success: true,
      });
    }
  }
);

export default profileRouter;
