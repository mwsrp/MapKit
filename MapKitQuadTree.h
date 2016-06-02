//
//  MapKitQuadTree.h
//  HelloCordova
//
//  Created by James Mattis on 6/1/16.
//
//

#import <Foundation/Foundation.h>

typedef struct MKQuadTreeNodeData {
    double x;
    double y;
    NSInteger data;
} MKQuadTreeNodeData;
MKQuadTreeNodeData MKQuadTreeNodeDataMake(double x, double y, NSInteger data);

typedef struct MKBoundingBox {
    double x0; double y0;
    double xf; double yf;
} MKBoundingBox;
MKBoundingBox MKBoundingBoxMake(double x0, double y0, double xf, double yf);

typedef struct quadTreeNode {
    struct quadTreeNode* northWest;
    struct quadTreeNode* northEast;
    struct quadTreeNode* southWest;
    struct quadTreeNode* southEast;
    MKBoundingBox boundingBox;
    int bucketCapacity;
    MKQuadTreeNodeData *points;
    int count;
} MKQuadTreeNode;
MKQuadTreeNode* MKQuadTreeNodeMake(MKBoundingBox boundary, int bucketCapacity);

void MKFreeQuadTreeNode(MKQuadTreeNode* node);

bool MKBoundingBoxContainsData(MKBoundingBox box, MKQuadTreeNodeData data);
bool MKBoundingBoxIntersectsBoundingBox(MKBoundingBox b1, MKBoundingBox b2);

typedef void(^MKQuadTreeTraverseBlock)(MKQuadTreeNode* currentNode);
void MKQuadTreeTraverse(MKQuadTreeNode* node, MKQuadTreeTraverseBlock block);

typedef void(^MKDataReturnBlock)(MKQuadTreeNodeData data);
void MKQuadTreeGatherDataInRange(MKQuadTreeNode* node, MKBoundingBox range, MKDataReturnBlock block);

bool MKQuadTreeNodeInsertData(MKQuadTreeNode* node, MKQuadTreeNodeData data);
MKQuadTreeNode* MKQuadTreeBuildWithData(MKQuadTreeNodeData *data, int count, MKBoundingBox boundingBox, int capacity);
