import React from "react";
import { Mutation } from "react-apollo";
import Textarea from "react-textarea-autosize";
import { textAreaClasses, labelClasses } from "../css/sharedTailwindClasses";
import { WEEK_IN_REVIEW_COMMENTS_QUERY } from "../queries/week_in_review_queries";
import {
  CREATE_COMMENT_MUTATION,
  UPDATE_COMMENT_MUTATION
} from "../mutations/commentMutations";

const findComment = (comments, type) => {
  const comment = comments.find(comment => comment.type === type);
  return comment
    ? comment
    : {
        body: ""
      };
};

const createOrUpdateVariables = (comment, weekInReviewId, body, type) => {
  if (comment.id) {
    return {
      id: comment.id,
      attributes: {
        weekInReviewId: weekInReviewId,
        body: body,
        type: type
      }
    };
  } else {
    return {
      attributes: {
        weekInReviewId: weekInReviewId,
        body: body,
        type: type
      }
    };
  }
};

const handleCommentBlur = async (
  e,
  comments,
  weekInReviewId,
  persistMutation
) => {
  const { value: body, name: type } = e.target;
  const comment = findComment(comments, type);
  const variables = createOrUpdateVariables(
    comment,
    weekInReviewId,
    body,
    type
  );

  await persistMutation({ variables: variables });
};

const saved = e => {
  if (e.createComment && e.createComment.errors[0]) return;
  if (e.updateComment && e.updateComment.errors[0]) return;

  const element = e.createComment
    ? document.getElementById(e.createComment.comment.type)
    : document.getElementById(e.updateComment.comment.type);

  element.innerHTML = "saved";
  setTimeout(() => {
    element.innerHTML = "";
  }, 2000);
};

const updateError = data =>
  data && data.updateComment && data.updateComment.errors[0];

const createError = data =>
  data && data.createComment && data.createComment.errors[0];

const displayError = data => {
  if (updateError(data)) {
    return data.updateComment.errors[0];
  } else if (createError(data)) {
    return "";
  } else {
    return "Validation error. Please try again.";
  }
};

const validationError = data => createError(data) || updateError(data);

const CommentTexarea = ({
  comments,
  date,
  type,
  onChange,
  weekInReviewId,
  labelContent
}) => (
  <Mutation
    mutation={
      findComment(comments, type).id
        ? UPDATE_COMMENT_MUTATION
        : CREATE_COMMENT_MUTATION
    }
    onCompleted={e => saved(e)}
    refetchQueries={() => [
      {
        query: WEEK_IN_REVIEW_COMMENTS_QUERY,
        variables: { date: date }
      }
    ]}
  >
    {(persistMutation, { error, data }) => {
      if (error) {
        return (
          <div>
            <span id={type} className="float-right text-teal-light text-xs" />
            <label className={labelClasses}> {labelContent} </label>
            <Textarea
              className={textAreaClasses}
              minRows={3}
              defaultValue={`Error!`}
            />
          </div>
        );
      }

      if (validationError(data)) {
        return (
          <div>
            <span id={type} className="float-right text-red text-xs">
              {displayError(data)}
            </span>
            <label className={labelClasses}> {labelContent} </label>
            <Textarea
              className={textAreaClasses}
              minRows={3}
              name={type}
              defaultValue={findComment(comments, type).body}
              onChange={onChange}
              onBlur={e => {
                handleCommentBlur(e, comments, weekInReviewId, persistMutation);
              }}
            />
          </div>
        );
      }

      return (
        <div>
          <span id={type} className="float-right text-teal-light text-xs" />
          <label className={labelClasses}>{labelContent}</label>
          <Textarea
            className={textAreaClasses}
            minRows={3}
            name={type}
            defaultValue={findComment(comments, type).body}
            onChange={onChange}
            onBlur={e => {
              handleCommentBlur(e, comments, weekInReviewId, persistMutation);
            }}
          />
        </div>
      );
    }}
  </Mutation>
);

export { CommentTexarea };
